//
//  Realgame.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

struct Realgame: Identifiable, Codable {
    let id: Int64?
    let unitPrice: Double
    let status: Status
    let name: String
    let editor: String
}
