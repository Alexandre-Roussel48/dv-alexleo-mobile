import Combine
import Foundation

class SellerSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service = SellerService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchClients()
            }
            .store(in: &cancellables)
    }
    
    private func searchClients() {
        guard !searchText.isEmpty else {
            clients = []
            return
        }
        
        isLoading = true
        Task {
            do {
                let results = try await service.searchClients(emailPrefix: searchText)
                await MainActor.run {
                    clients = results
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    isLoading = false
                }
            }
        }
    }
}

class SellerDetailsViewModel: ObservableObject {
    @Published var realgames: [Realgame] = []
    @Published var due: Double = 0
    @Published var withdrawn: Double = 0
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service = SellerService()
    
    func loadDetails(for client: Client) {
        guard let clientId = client.id else { return }
        
        isLoading = true
        Task {
            do {
                async let realgames = service.getRealgames(for: clientId)
                async let due = service.getDue(for: clientId)
                async let withdrawn = service.getWithdrawn(for: clientId)
                
                let (games, dueAmount, withdrawnAmount) = await (try realgames, try due, try withdrawn)
                
                await MainActor.run {
                    self.realgames = games
                    self.due = dueAmount
                    self.withdrawn = withdrawnAmount
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    isLoading = false
                }
            }
        }
    }
}
