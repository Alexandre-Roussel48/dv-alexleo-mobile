import Combine
import SwiftUI
import Foundation

class DepositFormViewModel: ObservableObject {
    @Published var gameName: String = ""
    @Published var quantity: String = ""
    @Published var unitPrice: String = ""
    
    @Published var selectedGame: Game?

    @Published var gameSuggestions: [Game] = []
    @Published var depositItems: [DepositItem] = []

    private let client: Client
    private let depositService: DepositService
    private var cancellables = Set<AnyCancellable>()

    init(client: Client) {
        self.client = client
        self.depositService = DepositService()

        // Observe changes to gameName and fetch games
        $gameName
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.fetchSuggestions(for: query)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchSuggestions(for query: String) async {
        guard query.count >= 2 else {
            DispatchQueue.main.async {
                self.gameSuggestions = []
            }
            return
        }

        do {
            let games = try await depositService.fetchGames(query: query)
            DispatchQueue.main.async {
                self.gameSuggestions = games
            }
        } catch {
            print("Error fetching games: \(error)")
        }
    }

    func selectGame(_ game: Game) {
        gameName = game.name
        selectedGame = game
        gameSuggestions = []
    }

    func addDepositItem() {
        guard let qty = Int(quantity),
              let price = Double(unitPrice),
              !gameName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        let game: Game

        if let selected = selectedGame {
            game = selected
        } else {
            game = Game(id: 0, name: gameName, editor: "Custom")
        }

        let item = DepositItem(quantity: qty, game: game, client: client, unitPrice: price)

        depositItems.append(item)
        clearFields()
    }

    func submitDeposit(completion: @escaping (Result<Void, Error>) -> Void) {
        depositService.saveDeposit(depositItems) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func clearFields() {
        gameName = ""
        quantity = ""
        unitPrice = ""
        gameSuggestions = []
        selectedGame = nil
    }
    
    var canAddDepositItem: Bool {
        selectedGame != nil &&
        gameName == selectedGame?.name &&
        Int(quantity) != nil &&
        Double(unitPrice) != nil &&
        !quantity.isEmpty &&
        !unitPrice.isEmpty
    }
}
