//
//  SessionInfoRow.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import SwiftUI

struct SessionInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

extension Text {
    func sessionButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(12)
            .shadow(color: Color.orange.opacity(0.3), radius: 5, y: 3)
    }
}
