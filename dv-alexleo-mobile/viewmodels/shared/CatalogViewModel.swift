import Foundation
import SwiftUI
import Combine

@MainActor
class CatalogViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet { fetchMatchingCatalog() }
    }
    @Published var games: [CatalogItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var priceRange: ClosedRange<Float> = 0...100

    private let catalogService: CatalogService = CatalogService()
    private var searchCancellable: AnyCancellable?
    private var debounceTimer: Timer?

    init() {
        fetchMatchingCatalog()
    }
    
    func fetchMatchingCatalog() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            Task {
                await self?.searchCatalog()
            }
        }
    }

    private func searchCatalog() async {
        do {
            let minPrice = max(0, Int(priceRange.lowerBound))
            let maxPrice = max(minPrice, Int(priceRange.upperBound))
            let results = try await catalogService.fetchCatalog(query: searchText, minPrice: minPrice, maxPrice: maxPrice)
            games = results
        } catch {
            games = []
            print("Fetch error: \(error)")
        }
    }
}
