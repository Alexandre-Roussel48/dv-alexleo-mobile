import Foundation

class SessionService {
    let session: URLSession
    
    private let baseURL = "\(Environment.baseURL)/admin/sessions"
    private let gestionURL = "\(Environment.baseURL)/gestion/sessions"
    init(session: URLSession = APIService.shared.session) {
        self.session = session
    }
    
    func fetchSessions() async throws -> [Session] {
            guard let url = URL(string: gestionURL) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                return try decoder.decode([Session].self, from: data)
            case 204: // No content
                return []
            default:
                throw URLError(.badServerResponse)
            }
        }

    
    func createSession(beginDate: Date, endDate: Date, commission: Double, fees: Double) async throws -> Session {
            guard let url = URL(string: baseURL) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Sans `Z`
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let body: [String: Any] = [
                "beginDate": dateFormatter.string(from: beginDate),
                "endDate": dateFormatter.string(from: endDate),
                "commission": commission,
                "fees": fees
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw URLError(.cannotCreateFile)
            }
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            switch httpResponse.statusCode {
            case 201:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(Session.self, from: data)
                
            case 204:
                    return Session(
                        id : nil,
                        beginDate: beginDate,
                        endDate: endDate,
                        commission: commission,
                        fees: fees
                    )
            case 401, 403:
                throw URLError(.userAuthenticationRequired)
            default:
                throw URLError(.badServerResponse)
            }
        }
    
    func updateSession(id: Int, beginDate: Date?, endDate: Date?, commission: Int?, fees: Int?) async throws -> Void {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [:]
        if let beginDate = beginDate { body["begin_date"] = beginDate.ISO8601Format() }
        if let endDate = endDate { body["end_date"] = endDate.ISO8601Format() }
        if let commission = commission { body["commission"] = commission }
        if let fees = fees { body["fees"] = fees }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        _ = try await session.data(for: request)
    }
    
    func deleteSession(id: Int64) async throws  {
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
