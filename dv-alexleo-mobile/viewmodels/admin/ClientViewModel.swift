import Foundation
import Combine

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let clientService: ClientService
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ClientService = ClientService()) {
        self.clientService = service
        setupBindings()
    }
    
    private func setupBindings() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                // Wrap the call in a Task to bridge to MainActor
                Task { [weak self] in
                    await self?.fetchClients()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchClients() async {  // Made this async
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            isLoading = true
            errorMessage = nil
            
            do {
                clients = try await clientService.fetchClients(email: searchText.isEmpty ? nil : searchText)
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                }
            }
            
            isLoading = false
        }
    }
    
    @MainActor
    func deleteClient(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await clientService.deleteClient(id: id)
            await fetchClients()  // Now properly awaited
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
