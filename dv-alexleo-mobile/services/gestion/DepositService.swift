//
//  DepositService.swift
//  depot-vente-frontend-mobile
//
//  Created by alexandre.roussel03 on 23/03/2025.
//

import Foundation

class DepositService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/gestion"
    
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func createClient(client: ClientRegistration) async throws -> Client {
        let url = URL(string: "\(baseURL)/clients")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(client)
        
        let (data, _) = try await session.data(for: request)
        let client = try JSONDecoder().decode(Client.self, from: data)
        return client
    }
    
    func getClient(email: String) async throws -> [Client] {
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/clients?email=\(encodedEmail)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        let clients = try JSONDecoder().decode([Client].self, from: data)
        return clients
    }
    
    func saveDeposit(_ items: [DepositItem], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/deposits") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(items)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = session.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            completion(.success(()))
        }

        task.resume()
    }
    
    func fetchGames(query: String) async throws -> [Game] {
        guard let url = URL(string: "\(baseURL)/games?query=\(query)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        let games = try JSONDecoder().decode([Game].self, from: data)
        return games
    }
}
