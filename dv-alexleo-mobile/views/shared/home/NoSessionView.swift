//
//  NoSessionView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import SwiftUI

struct NoSessionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Aucune session active")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Revenez ultérieurement pour voir les sessions programmées")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
