//
//  CatalogItem.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//


import Foundation

struct CatalogItem: Codable {
    let unitPrice: Double
    let quantity: Int
    let gameName: String
    let gameEditor: String
    let sellerName: String
    let sellerSurname: String

    var sellerFullName: String {
        "\(sellerName) \(sellerSurname)"
    }
}
