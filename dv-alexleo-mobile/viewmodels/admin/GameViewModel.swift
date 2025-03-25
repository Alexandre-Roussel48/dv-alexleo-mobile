import Foundation

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let gameService: GameService
    
    init(service: GameService = GameService()) {
        self.gameService = service
        Task {
            await fetchGames()
        }
    }
    
    @MainActor
    func fetchGames(query: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            games = try await gameService.fetchGames(query: query)
            print("jeux: \(games)")
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur fetchGames: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func createGame(name: String, editor: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await gameService.createGame(name: name, editor: editor)
            await fetchGames()
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur createGame: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateGame(id: Int, name: String?, editor: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await gameService.updateGame(id: id, name: name, editor: editor)
            await fetchGames()
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur updateGame: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func deleteGame(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await gameService.deleteGame(id: id)
            await fetchGames()
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur deleteGame: \(error)")
        }
        
        isLoading = false
    }
}
