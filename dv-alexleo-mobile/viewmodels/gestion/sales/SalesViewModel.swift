import Foundation
import Combine

class SalesViewModel: ObservableObject {
    @Published var gameName: String = ""
    @Published var selectedGames: [Realgame] = []
    @Published var gameSuggestions: [Realgame] = []
    @Published var selectedGame: Realgame? = nil

    private let salesService: SalesService = SalesService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeGameSearch()
    }

    private func observeGameSearch() {
        $gameName
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }

                // Cancel suggestions if query is empty
                if query.isEmpty {
                    self.gameSuggestions = []
                    return
                }

                Task { @MainActor in
                    do {
                        let games = try await self.salesService.fetchGames(query: query)
                        self.gameSuggestions = games
                    } catch {
                        print("Erreur lors de la récupération des jeux :", error)
                        self.gameSuggestions = []
                    }
                }
            }
            .store(in: &cancellables)
    }

    func selectGame(_ game: Realgame) {
        self.selectedGame = game
        self.gameName = game.name
        self.gameSuggestions = []
    }

    func addSelectedGame() {
        guard let selected = selectedGame else { return }
        selectedGames.append(selected)
        gameName = ""
        selectedGame = nil
    }
    
    func validateSale(completion: @escaping (Result<Void, Error>) -> Void) {
        salesService.validateSale(selectedGames) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        selectedGames.removeAll()
    }
}
