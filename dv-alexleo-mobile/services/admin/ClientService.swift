import Foundation
import Combine


class ClientService {
    private let baseURL = "\(Environment.baseURL)/admin/clients"
    private let gestionURL = "\(Environment.baseURL)/gestion/clients"
    
    func fetchClients(email: String?) -> AnyPublisher<[Client], Error> {
        var components = URLComponents(string: gestionURL)!
        if let email = email, !email.isEmpty {
            components.queryItems = [URLQueryItem(name: "email", value: email)]
        }
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Client].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func deleteClient(id: Int) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)?id=\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
