import Foundation
import Combine

class CatalogService {
    private let baseURL = "\(Environment.baseURL)/catalog"
    
    func fetchCatalog(query: String?, minPrice: Int?, maxPrice: Int?) async throws -> [CatalogItem] {
        var components = URLComponents(string: baseURL)!

        var queryItems: [URLQueryItem] = []

        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        if let minPrice = minPrice {
            queryItems.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
        }
        if let maxPrice = maxPrice {
            queryItems.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let items = try JSONDecoder().decode([CatalogItem].self, from: data)
        return items
    }
}
