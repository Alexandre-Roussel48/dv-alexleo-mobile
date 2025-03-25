//
//  DepositView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//
import SwiftUI

struct DepositView: View {
    @StateObject private var clientAuthViewModel = ClientAuthViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ClientAuthView(viewModel: clientAuthViewModel) {
                if let client = clientAuthViewModel.selectedClient {
                    path.append(client)
                }
            }
            .navigationDestination(for: Client.self) { client in
                DepositFormView(client: client)
            }
        }
    }
}
