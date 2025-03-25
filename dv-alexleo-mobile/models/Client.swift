//
//  Client.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

import Foundation

struct Client: Identifiable, Codable, Equatable, Hashable {
    let id: Int64?
    let name: String
    let surname: String
    let email: String
    let phoneNumber: String
    let address: String?

    var fullName: String {
        "\(name) \(surname)"
    }
}
