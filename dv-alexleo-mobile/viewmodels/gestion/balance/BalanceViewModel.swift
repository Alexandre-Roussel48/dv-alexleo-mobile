import Foundation

class BalanceViewModel: ObservableObject {
    @Published var depositFees = 0
    @Published var dues = 0
    @Published var commissions = 0
    @Published var paid = 0
    @Published var treasury = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = BalanceService()
    
    @MainActor
    func fetchAllMetrics() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let fees = service.getDepositFees()
            async let dues = service.getDues()
            async let commissions = service.getCommissions()
            async let paid = service.getPaid()
            async let treasury = service.getTreasury()
            
            let results = try await [fees, dues, commissions, paid, treasury]
            
            depositFees = results[0]
            self.dues = results[1]
            self.commissions = results[2]
            self.paid = results[3]
            self.treasury = results[4]
            
        } catch {
            errorMessage = handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) -> String {
        switch error {
        case URLError.badServerResponse:
            return "Erreur serveur"
        case URLError.userAuthenticationRequired:
            return "Authentification requise"
        default:
            return "Erreur de connexion"
        }
    }
}
