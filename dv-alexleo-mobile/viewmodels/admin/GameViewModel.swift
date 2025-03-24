import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let gameService: GameService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: GameService = GameService()) {
        self.gameService = service
        fetchGames()
    }
    
    func fetchGames(query: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        gameService.fetchGames(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] games in
                self?.games = games
            }
            .store(in: &cancellables)
    }
    
    func createGame(name: String, editor: String) {
        isLoading = true
        errorMessage = nil
        
        gameService.createGame(name: name, editor: editor)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchGames()
            }
            .store(in: &cancellables)
    }
    
    func updateGame(id: Int, name: String?, editor: String?) {
        isLoading = true
        errorMessage = nil
        
        gameService.updateGame(id: id, name: name, editor: editor)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchGames()
            }
            .store(in: &cancellables)
    }
    
    func deleteGame(id: Int) {
        isLoading = true
        errorMessage = nil
        
        gameService.deleteGame(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchGames()
            }
            .store(in: &cancellables)
    }
}
