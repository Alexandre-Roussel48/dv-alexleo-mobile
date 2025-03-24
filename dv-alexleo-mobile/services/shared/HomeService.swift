import Foundation


class HomeService {
    private let baseURL = "http://votre-api.com/api/session"
    
    func fetchCurrentSession(completion: @escaping (Result<Session?, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "URL invalide", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Réponse invalide", code: 0)))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.success(nil))
                    return
                }
                
                do {
                    let session = try JSONDecoder().decode(Session.self, from: data)
                    completion(.success(session))
                } catch {
                    completion(.failure(error))
                }
                
            case 404:
                completion(.success(nil))
                
            default:
                let error = NSError(domain: "Erreur serveur", code: httpResponse.statusCode)
                completion(.failure(error))
            }
        }.resume()
    }
}
