import SwiftUI

struct ClientView: View {
    @StateObject private var viewModel = ClientViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, placeholder: "Rechercher par email")
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("Erreur : \(error)")
                        .foregroundColor(.red)
                } else if viewModel.clients.isEmpty {
                    Text("Aucun client trouvé")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.clients) { client in
                            VStack(alignment: .leading) {
                                Text(client.email)
                                    .font(.headline)
                            }
                            .swipeActions {
                                Button("Supprimer", role: .destructive) {
                                    viewModel.deleteClient(id: client.id)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Clients")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
    }
}
