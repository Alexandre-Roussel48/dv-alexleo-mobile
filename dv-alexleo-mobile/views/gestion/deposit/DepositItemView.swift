//
//  DepositItemView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 25/03/2025.
//
import SwiftUI

struct DepositItemView: View {
    let item: DepositItem

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(item.game.name) – \(item.quantity) x \(String(format: "%.2f", item.unitPrice))€")
                .font(.body)
            Text("Total: \(String(format: "%.2f", Double(item.quantity) * item.unitPrice))€")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
