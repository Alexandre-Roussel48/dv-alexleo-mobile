import Foundation
import Combine

class GameService {
    
    func fetchGames(query: String? = nil) -> AnyPublisher<[Game], Error> {
        var urlComponents = URLComponents(string: baseURL)!
        if let query = query {
            urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        }
        
        let request = URLRequest(url: urlComponents.url!)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [Game].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createGame(name: String, editor: String) -> AnyPublisher<Void, Error> {
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": name, "editor": editor]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func updateGame(id: Int, name: String?, editor: String?) -> AnyPublisher<Void, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String?] = ["name": name, "editor": editor]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteGame(id: Int) -> AnyPublisher<Void, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
