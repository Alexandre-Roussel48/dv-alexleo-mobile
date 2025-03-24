//
//  APIService.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import Foundation

class APIService {
    static let shared = APIService()

    let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthInterceptorURLProtocol.self] + (config.protocolClasses ?? [])
        self.session = URLSession(configuration: config)
    }
}
