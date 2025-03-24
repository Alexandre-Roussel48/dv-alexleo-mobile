import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: AuthService = AuthService()) {
        self.authService = service
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isLoading = false
                switch result {
                case .failure(let error):
                    self?.handleLoginError(error)
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { token in
                // Stockez le token ici (par exemple, dans Keychain ou UserDefaults)
                print("Token reçu : \(token)")
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    private func handleLoginError(_ error: Error) {
        if let urlError = error as? URLError,
               let httpResponse = urlError.userInfo[NSURLErrorKey] as? HTTPURLResponse,
               httpResponse.statusCode == 401 {
                errorMessage = "Identifiants incorrects"
            } else {
                errorMessage = "Erreur de connexion"
            }
    }
}
