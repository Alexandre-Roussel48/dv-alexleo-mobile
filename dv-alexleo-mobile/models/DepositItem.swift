//
//  DepositItem.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

import Foundation

struct DepositItem: Codable {
    let quantity: Int
    let game: Game
    let client: Client
}
