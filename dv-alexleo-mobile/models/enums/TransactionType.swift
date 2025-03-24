//
//  TransactionType.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//


enum TransactionType: String, Codable {
    case deposit = "DEPOSIT"
    case commission = "COMMISSION"
    case sale = "SALE"
    case pay = "PAY"
}
