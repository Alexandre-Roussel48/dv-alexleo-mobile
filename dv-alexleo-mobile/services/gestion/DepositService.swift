//
//  DepositService.swift
//  depot-vente-frontend-mobile
//
//  Created by alexandre.roussel03 on 23/03/2025.
//

import Foundation

class DepositService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/gestion/clients"

    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func createClient(client: ClientRegistration) async throws -> Client {
            let url = URL(string: baseURL)!
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
                  let url = URL(string: "\(baseURL)?email=\(encodedEmail)") else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let (data, _) = try await session.data(for: request)
            let clients = try JSONDecoder().decode([Client].self, from: data)
            return clients
        }}
