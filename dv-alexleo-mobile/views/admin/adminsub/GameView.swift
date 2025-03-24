import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showCreateGame = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.games) { game in
                    NavigationLink(destination: GameDetailView(game: game, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(game.name)
                                .font(.headline)
                            Text(game.editor)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteGame)
            }
            .navigationTitle("Jeux")
            .toolbar {
                Button(action: { showCreateGame = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showCreateGame) {
                CreateGameView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteGame(at offsets: IndexSet) {
        for index in offsets {
            let game = viewModel.games[index]
            viewModel.deleteGame(id: game.id)
        }
    }
}

struct GameDetailView: View {
    let game: Game
    @ObservedObject var viewModel: GameViewModel
    @State private var showEditGame = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(game.name)
                .font(.title)
            Text(game.editor)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button("Modifier") {
                showEditGame = true
            }
            .sheet(isPresented: $showEditGame) {
                EditGameView(game: game, viewModel: viewModel)
            }
        }
        .padding()
        .navigationTitle("Détails du jeu")
    }
}

struct CreateGameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var name = ""
    @State private var editor = ""
    
    var body: some View {
        Form {
            TextField("Nom", text: $name)
            TextField("Éditeur", text: $editor)
            
            Button("Créer") {
                viewModel.createGame(name: name, editor: editor)
            }
        }
        .navigationTitle("Nouveau jeu")
    }
}

struct EditGameView: View {
    let game: Game
    @ObservedObject var viewModel: GameViewModel
    @State private var name = ""
    @State private var editor = ""
    
    var body: some View {
        Form {
            TextField("Nom", text: $name)
            TextField("Éditeur", text: $editor)
            
            Button("Enregistrer") {
                viewModel.updateGame(id: game.id, name: name, editor: editor)
            }
        }
        .onAppear {
            name = game.name
            editor = game.editor
        }
        .navigationTitle("Modifier le jeu")
    }
}
