import Foundation

class GameService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/admin/games"
    private let gestionURL = "\(Environment.baseURL)/gestion/games"

    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func fetchGames(query: String? = nil) async throws -> [Game] {
        
        var urlComponents = URLComponents(string: gestionURL)!
        if let query = query {
            urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([Game].self, from: data)
    }
    
    func createGame(name: String, editor: String) async throws -> Void {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["name": name, "editor": editor])

        _ = try await session.data(for: request)
    }
    
    func updateGame(id: Int, name: String?, editor: String?) async throws -> Void {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["name": name, "editor": editor])

        _ = try await session.data(for: request)
    }
    
    func deleteGame(id: Int) async throws -> Void {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        _ = try await session.data(for: request)
    }
}
