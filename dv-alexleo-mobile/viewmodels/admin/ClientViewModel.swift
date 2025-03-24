import Foundation
import Combine

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let clientService: ClientService
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
                self?.fetchClients()
            }
            .store(in: &cancellables)
    }
    
    func fetchClients() {
        isLoading = true
        errorMessage = nil
        
        clientService.fetchClients(email: searchText.isEmpty ? nil : searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] clients in
                self?.clients = clients
            }
            .store(in: &cancellables)
    }
    
    func deleteClient(id: Int) {
        isLoading = true
        errorMessage = nil
        
        clientService.deleteClient(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchClients()
            }
            .store(in: &cancellables)
    }
}
