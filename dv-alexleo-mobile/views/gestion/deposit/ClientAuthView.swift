import SwiftUI

struct ClientAuthView: View {
    @ObservedObject var viewModel: ClientAuthViewModel
    var onTermine: () -> Void
    
    @ViewBuilder
    private var matchingClientList: some View {
        if !viewModel.isRegistering && !viewModel.matchingClients.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Clients correspondants")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.matchingClients) { client in
                            ClientRowView(
                                client: client,
                                isSelected: viewModel.selectedClient == client
                            ) {
                                viewModel.selectedClient = client
                                viewModel.email = client.email
                            }
                        }
                    }
                }
                .frame(height: 150)
            }
        }
    }

    @ViewBuilder
    private var registrationFields: some View {
        if viewModel.isRegistering {
            StyledTextField(placeholder: "Prénom", text: $viewModel.name)
            StyledTextField(placeholder: "Nom", text: $viewModel.surname)
            StyledTextField(placeholder: "Numéro de téléphone", text: $viewModel.phoneNumber, keyboardType: .numberPad)
            StyledTextField(placeholder: "Adresse", text: $viewModel.address)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer(minLength: geometry.size.height > 600 ? (geometry.size.height - 500) / 2 : 24)

                    VStack(spacing: 24) {
                        // Title
                        Text(viewModel.isRegistering ? "Nouveau vendeur" : "Déjà vendeur")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Email Field
                        StyledTextField(placeholder: "Email", text: $viewModel.email, keyboardType: .emailAddress)

                        // Matching clients
                        matchingClientList

                        // Registration fields
                        registrationFields

                        // Submit button
                        Button(action: {
                            Task {
                                if viewModel.isRegistering {
                                    await viewModel.registerClient()
                                }
                            }
                            onTermine()
                        }) {
                            Text(viewModel.isRegistering ? "Créer compte" : "Sélectionner")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.orange)
                                .cornerRadius(10)
                        }
                        .shadow(color: .red.opacity(0.2), radius: 10, y: 4)

                        // Toggle
                        Button(action: {
                            viewModel.isRegistering.toggle()
                        }) {
                            Text(viewModel.isRegistering
                                  ? "Déjà vendeur ? Sélectionner un client"
                                  : "Pas de compte ? Enregistrer un nouveau client")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                        }
                    }
                    .padding(24)

                    Spacer(minLength: 24)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}
