//
//  ClientRegistration.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//


import Foundation

struct ClientRegistration: Codable {
    let name: String
    let surname: String
    let email: String
    let phoneNumber: String
    let address: String?
}
