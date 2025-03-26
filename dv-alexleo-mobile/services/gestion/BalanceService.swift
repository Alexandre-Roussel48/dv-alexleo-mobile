import Foundation

class BalanceService {
    private let baseURL = "\(Environment.baseURL)/gestion/totals"
    private let session: URLSession
    
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    private func fetchMetric(_ path: String) async throws -> Int {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ No valid HTTP response received")
                throw URLError(.badServerResponse)
            }
        print("📥 Response Status Code: \(httpResponse.statusCode)")
        let stringValue = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let result = Int(stringValue.components(separatedBy: ".").first ?? "") ?? 0
        
        return result

    }
    
    func getDepositFees() async throws -> Int {
        try await fetchMetric("fee")
    }
    
    func getDues() async throws -> Int {
        try await fetchMetric("due")
    }
    
    func getCommissions() async throws -> Int {
        try await fetchMetric("commission")
    }
    
    func getPaid() async throws -> Int {
        try await fetchMetric("paid")
    }
    
    func getTreasury() async throws -> Int {
        try await fetchMetric("treasury")
    }
}
