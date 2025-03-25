import Foundation

class ClientService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/admin/clients"
    private let gestionURL = "\(Environment.baseURL)/gestion/clients"
    
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func fetchClients(email: String? = nil) async throws -> [Client] {
        var urlComponents = URLComponents(string: gestionURL)!
        if let email = email, !email.isEmpty {
            urlComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([Client].self, from: data)
    }
    
    func deleteClient(id: Int) async throws -> Void {
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
