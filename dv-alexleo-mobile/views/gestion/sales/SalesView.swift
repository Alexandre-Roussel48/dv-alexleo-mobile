import SwiftUI

struct SalesView: View {
    @StateObject private var viewModel = SalesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Nom du jeu")
                        .font(.headline)
                    
                    TextField("Rechercher un jeu", text: $viewModel.gameName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Suggestions dropdown
                    if !viewModel.gameSuggestions.isEmpty &&
                        (viewModel.selectedGame == nil || viewModel.selectedGame?.name != viewModel.gameName) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.gameSuggestions, id: \.id) { game in
                                Button(action: {
                                    viewModel.selectGame(game)
                                }) {
                                    HStack {
                                        Text(game.name)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(game.editor)-\(game.id!)")
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

                    Button("Ajouter le jeu") {
                        viewModel.addSelectedGame()
                    }
                    .disabled(viewModel.selectedGame == nil)
                    .buttonStyle(.borderedProminent)

                    Text("Jeux sélectionnés")
                        .font(.headline)

                    ForEach(viewModel.selectedGames) { game in
                        VStack(alignment: .leading) {
                            Text(game.name)
                                .font(.headline)
                            Text("Éditeur : \(game.editor)")
                                .font(.subheadline)
                            Text("Prix : \(String(format: "%.2f", game.unitPrice)) €")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 6)
                        Divider()
                    }

                    Spacer()

                    Button("Valider la vente") {
                        viewModel.validateSale() { result in
                            switch result {
                            case .success:
                                print("Sale submitted successfully.")
                            case .failure(let error):
                                print("Failed to submit sale: \(error)")
                            }
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                }
                .padding()
                .navigationTitle("Nouvelle Vente")
            }
        }
    }
}
