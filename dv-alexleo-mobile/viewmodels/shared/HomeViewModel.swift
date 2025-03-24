import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentSession: Session?
    
    private let homeService: HomeService
    
    init(service: HomeService = HomeService()) {
        self.homeService = service
        fetchSession()
    }
    
    func fetchSession() {
        isLoading = true
        errorMessage = nil
        
        homeService.fetchCurrentSession { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let session):
                    self?.currentSession = session
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
