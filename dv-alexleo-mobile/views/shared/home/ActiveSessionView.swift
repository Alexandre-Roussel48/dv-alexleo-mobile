//
//  ActiveSessionView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import SwiftUI

struct ActiveSessionView: View {
    let session: Session
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 24) {
                Text("Session en cours")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                VStack(spacing: 12) {
                    SessionInfoRow(title: "Début", value: session.beginDate.formatted())
                    SessionInfoRow(title: "Fin", value: session.endDate.formatted())
                    SessionInfoRow(title: "Commission", value: "\(session.commission) %")
                    SessionInfoRow(title: "Frais", value: "\(session.fees) %")
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 5)

                Spacer()

                Button(action: {
                    navigationPath.append("CatalogView")
                }) {
                    Text("Accéder à la session")
                        .sessionButtonStyle()
                }

                Spacer()
            }
            .padding(.top, 40)
            .navigationDestination(for: String.self) { destination in
                if destination == "CatalogView" {
                    CatalogView()
                }
            }
        }
    }
}
