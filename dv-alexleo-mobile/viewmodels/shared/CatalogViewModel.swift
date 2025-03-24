import Foundation
import Combine

class CatalogViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var games: [Realgame] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var priceRange: ClosedRange<Float> = 0...100
    private var cancellables = Set<AnyCancellable>()
    private let catalogService: CatalogService
    
    init(service: CatalogService = CatalogService()) {
        self.catalogService = service
        setupBindings()
    }
    
    private func setupBindings() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.fetchCatalog()
            }
            .store(in: &cancellables)
    }
    
    func fetchCatalog() {
        isLoading = true
        errorMessage = nil
    
        let minPrice = max(0, Int(priceRange.lowerBound))
        let maxPrice = max(minPrice, Int(priceRange.upperBound))
        
        catalogService.fetchCatalog(
            query: searchText.isEmpty ? nil : searchText,
            minPrice: minPrice,
            maxPrice: maxPrice
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] games in
            self?.games = games
        }
        .store(in: &cancellables)
    }
}
