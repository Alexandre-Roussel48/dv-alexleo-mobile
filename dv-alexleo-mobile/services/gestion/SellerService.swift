import Foundation

class SellerService {
    private let baseURL = "\(Environment.baseURL)/gestion/clients"
    private let session: URLSession
    
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func searchClients(emailPrefix: String) async throws -> [Client] {
        guard let url = URL(string: "\(baseURL)?email=\(emailPrefix)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Client].self, from: data)
    }
    
    func getRealgames(for clientId: Int64) async throws -> [Realgame] {
        guard let url = URL(string: "\(baseURL)/realgames?id=\(clientId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Realgame].self, from: data)
    }
    
    func getDue(for clientId: Int64) async throws -> Double {
        guard let url = URL(string: "\(baseURL)/due?id=\(clientId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        let stringValue = String(data: data, encoding: .utf8) ?? "0"
        return Double(stringValue) ?? 0
    }

    func getWithdrawn(for clientId: Int64) async throws -> Double {
        guard let url = URL(string: "\(baseURL)/withdrawn?id=\(clientId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        let stringValue = String(data: data, encoding: .utf8) ?? "0"
        return Double(stringValue) ?? 0
    }
}
