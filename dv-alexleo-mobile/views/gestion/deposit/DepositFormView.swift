import SwiftUI

struct DepositFormView: View {
    @StateObject private var viewModel: DepositFormViewModel

    init(client: Client) {
        _viewModel = StateObject(wrappedValue: DepositFormViewModel(client: client))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    formFieldsSection
                    depositItemsSection
                        .padding(.bottom, 16)
                }
                .padding()
            }

            Divider()

            // Fixed button at the bottom
            Button(action: {
                viewModel.submitDeposit { result in
                    switch result {
                    case .success:
                        print("Deposit submitted successfully.")
                    case .failure(let error):
                        print("Failed to submit deposit: \(error)")
                    }
                }
            }) {
                Text("Enregistrer le dépôt")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(UIColor.systemBackground).shadow(radius: 2))
        }
        .navigationTitle("Déposer des jeux")
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var formFieldsSection: some View {
        VStack(spacing: 16) {
            Text("Ajouter un jeu")
                .font(.headline)
            
            TextField("Nom du jeu", text: $viewModel.gameName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !viewModel.gameSuggestions.isEmpty && (viewModel.selectedGame == nil || viewModel.selectedGame?.name != viewModel.gameName) {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.gameSuggestions, id: \.id) { game in
                        Button(action: {
                            viewModel.selectGame(game)
                        }) {
                            HStack {
                                Text(game.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(game.editor)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            TextField("Quantité", text: $viewModel.quantity)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Prix unitaire (€)", text: $viewModel.unitPrice)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                viewModel.addDepositItem()
            }) {
                Text("Ajouter au dépôt")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.canAddDepositItem ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.canAddDepositItem)
        }
    }

    private var depositItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Jeux déposés")
                .font(.headline)

            if viewModel.depositItems.isEmpty {
                Text("Aucun jeu ajouté pour le moment.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.depositItems) { item in
                    DepositItemView(item: item)
                }
            }
        }
    }
}
