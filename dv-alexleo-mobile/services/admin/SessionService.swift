import Foundation
import Combine


class SessionService {
    private let baseURL = "\(Environment.baseURL)api/admin/sessions"
    
    func fetchCurrentSession() -> AnyPublisher<Session?, Error> {
        guard let url = URL(string: "\(baseURL)/current") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Session?.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func createSession(beginDate: Date, endDate: Date, commission: Int, fees: Int) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "begin_date": beginDate.ISO8601Format(),
            "end_date": endDate.ISO8601Format(),
            "commission": commission,
            "fees": fees
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func updateSession(id: Int, beginDate: Date?, endDate: Date?, commission: Int?, fees: Int?) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)?id=\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [:]
        if let beginDate = beginDate { body["begin_date"] = beginDate.ISO8601Format() }
        if let endDate = endDate { body["end_date"] = endDate.ISO8601Format() }
        if let commission = commission { body["commission"] = commission }
        if let fees = fees { body["fees"] = fees }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func deleteSession(id: Int) -> AnyPublisher<Void, Error> {
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
