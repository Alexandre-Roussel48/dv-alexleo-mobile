//
//  Untitled.swift
//  depot-vente-frontend-mobile
//
//  Created by alexandre.roussel03 on 23/03/2025.
//

import SwiftUI

struct DepositView: View {
    
    var body: some View {
        ClientAuthView()
    }
}

struct Deposit_Previews: PreviewProvider {
    static var previews: some View {
        DepositView()
    }
}

struct ClientAuthView: View {
    @StateObject private var viewModel = ClientAuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.isRegistering ? "Nouveau vendeur" : "Déjà vendeur")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            
            if !viewModel.isRegistering && !viewModel.matchingClients.isEmpty {
                List(viewModel.matchingClients) { client in
                    Button(action: {
                        viewModel.selectedClient = client
                        viewModel.email = client.email
                    }) {
                        Text(client.email)
                    }
                }
                .frame(height: 150)
            }

            if viewModel.isRegistering {
                TextField("Prénom", text: $viewModel.name)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                TextField("Nom", text: $viewModel.surname)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                TextField("Numéro de téléphone", text: $viewModel.phoneNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                TextField("Adresse", text: $viewModel.address)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }

            Button(action: {
                Task {
                    if viewModel.isRegistering {
                        await viewModel.registerClient()
                    }
                }
            }) {
                Text(viewModel.isRegistering ? "Créer compte" : "Sélectionner")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange)
                    .cornerRadius(10)
            }
            .shadow(color: .red, radius: 15, y: 5)

            Button(action: {
                viewModel.isRegistering.toggle()
            }) {
                Text(viewModel.isRegistering ? "Déjà vendeur? Sélectionner un client" : "Pas de compte? Enregister un nouveau client")
                    .font(.footnote)
            }
        }
        .padding()
    }
}
