import Foundation
import Combine



class AuthService {
    private let baseURL = "\(Environment.baseURL)/auth/login"
    
    func login(email: String, password: String) -> AnyPublisher<String, Error> {
        let loginRequest = LoginRequest(email: email, password: password)
        
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .map { $0.token }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
