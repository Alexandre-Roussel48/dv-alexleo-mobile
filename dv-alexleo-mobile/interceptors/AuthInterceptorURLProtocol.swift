//
//  AuthInterceptorURLProtocol.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//


import Foundation

class AuthInterceptorURLProtocol: URLProtocol {
    static var token: String?

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "Handled", in: request) != nil {
            return false
        }

        // Skip specific paths
        if let path = request.url?.path,
           path.contains("/api/login") || path.contains("/api/session") || path.contains("/api/catalog") {
            return false
        }

        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let token = AuthInterceptorURLProtocol.token else {
            client?.urlProtocol(self, didFailWithError: URLError(.userAuthenticationRequired))
            return
        }

        // Create a mutable copy of the request
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        // Mark as handled to avoid infinite loops
        URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)

        // Add Authorization header
        mutableRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Use normal URLSession to perform the request
        let task = URLSession.shared.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }

        task.resume()
    }
}
