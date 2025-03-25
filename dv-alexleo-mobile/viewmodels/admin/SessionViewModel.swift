import Foundation

class SessionViewModel: ObservableObject {
    @Published var currentSession: Session?
    @Published var allSessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let sessionService: SessionService
    private let homeService : HomeService
    
    init(service: SessionService = SessionService(), homeService: HomeService = HomeService()) {
        self.sessionService = service;
        self.homeService = homeService
    }
    
    func fetchCurrentSession() {
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

    @MainActor
    func createSession(beginDate: Date, endDate: Date, commission: Double, fees: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let newSession = try await sessionService.createSession(
                beginDate: beginDate,
                endDate: endDate,
                commission: commission,
                fees: fees
            )
            currentSession = newSession
        } catch {
            errorMessage = handleError(error)
            print("Erreur création session: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .userAuthenticationRequired:
                return "Authentification requise"
            case .badServerResponse:
                return "Erreur serveur (code: \((error as NSError).code)"
            default:
                return "Erreur réseau: \(urlError.localizedDescription)"
            }
        }
        return error.localizedDescription
    }

    
    @MainActor
    func updateSession(id: Int, beginDate: Date?, endDate: Date?, commission: Int?, fees: Int?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await sessionService.updateSession(
                id: id,
                beginDate: beginDate,
                endDate: endDate,
                commission: commission,
                fees: fees
            )
              fetchCurrentSession()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func deleteSession() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Récupère toutes les sessions
            allSessions = try await sessionService.fetchSessions()
            
            // Prend la première session comme session actuelle
            currentSession = allSessions.first
            
            guard let sessionToDelete = currentSession,
                  let sessionId = sessionToDelete.id else {
                errorMessage = "Aucune session à supprimer"
                isLoading = false
                return
            }
            
            // Supprime la session
            try await sessionService.deleteSession(id: sessionId)
            
            // Met à jour les données
            fetchCurrentSession()
            allSessions = try await sessionService.fetchSessions()
            
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur lors de la suppression: \(error)")
        }
        
        isLoading = false
    }
    
}
