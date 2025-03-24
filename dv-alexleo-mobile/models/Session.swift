//
//  Session.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import Foundation

struct Session: Codable {
    let id: Int64?
    let beginDate: Date
    let endDate: Date
    let commission: Double
    let fees: Double
}
