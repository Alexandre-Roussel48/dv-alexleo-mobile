//
//  dv_alexleo_mobileApp.swift
//  dv-alexleo-mobile
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

@main
struct dv_alexleo_mobileApp: App {
    init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthInterceptorURLProtocol.self] + (config.protocolClasses ?? [])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
