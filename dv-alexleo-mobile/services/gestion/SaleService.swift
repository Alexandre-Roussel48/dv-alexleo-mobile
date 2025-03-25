//
//  SaleService.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

import Foundation

class SalesService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/gestion/sales"
    
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func fetchGames(query: String) async throws -> [Realgame] {
        guard let url = URL(string: "\(baseURL)/realgames?query=\(query)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        let realgames = try JSONDecoder().decode([Realgame].self, from: data)
        return realgames
    }

    func validateSale(_ items: [Realgame], completion: @escaping (Result<Void, Error>) -> Void) {
        let ids = items.compactMap { $0.id }
            guard let url = URL(string: "\(baseURL)") else {
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let body = try JSONEncoder().encode(ids)
                request.httpBody = body

                session.dataTask(with: request) { _, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          200..<300 ~= httpResponse.statusCode else {
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }

                    completion(.success(()))
                }.resume()
            } catch {
                completion(.failure(error))
            }
    }
}
