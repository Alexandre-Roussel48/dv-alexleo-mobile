//
//  Transaction.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import Foundation

struct Transaction: Codable {
    let date: Date
    let value: Double
    let type: TransactionType
}
