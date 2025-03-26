import SwiftUI
import Foundation

struct ClientSearchView: View {
    @StateObject private var searchVM = SellerSearchViewModel()
    @StateObject private var detailsVM = SellerDetailsViewModel()
    @State private var selectedClient: Client?
    var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    searchField
                    
                    if searchVM.isLoading {
                        ProgressView()
                            .padding()
                    } else if !searchVM.clients.isEmpty {
                        clientList
                    } else {
                        emptyState
                    }
                }
                .navigationTitle("Recherche Clients")
                .alert("Erreur", isPresented: .constant(searchVM.error != nil)) {
                    Button("OK") { searchVM.error = nil }
                } message: {
                    Text(searchVM.error?.localizedDescription ?? "")
                }
            }
        }
        
        // Déplacer les propriétés calculées en dehors du body
        private var searchField: some View {
            HStack {
                TextField("Rechercher par email...", text: $searchVM.searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                
                if !searchVM.searchText.isEmpty {
                    Button {
                        searchVM.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
            }
        }
        
        private var clientList: some View {
            List(searchVM.clients) { client in
                NavigationLink {
                    ClientDetailView(client: client,vm: detailsVM)
                } label: {
                    VStack(alignment: .leading) {
                        Text(client.fullName)
                            .font(.headline)
                        Text(client.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(.plain)
        }
        
        private var emptyState: some View {
            VStack {
                Image(systemName: "person.3")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                Text("Commencez à taper un email pour rechercher des clients")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }

struct ClientDetailView: View {
    let client: Client
    @StateObject var vm = SellerDetailsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                TabView {
                    realgamesTab
                        .padding(.bottom) // Ajout d'espace pour le défilement
                    
                    financialTab
                        .padding(.bottom)
                }
                .tabViewStyle(.page)
                .frame(height: UIScreen.main.bounds.height * 0.5) // Hauteur adaptable
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer() // Permet de pousser le contenu vers le haut
            }
            .frame(maxWidth: .infinity) // Remplit toute la largeur
            .padding()
        }
        .navigationTitle(client.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Erreur", isPresented: .constant(vm.error != nil)) {
            Button("OK") { vm.error = nil }
        }
        .onAppear {
            vm.loadDetails(for: client)
        }
    }
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(client.fullName)
                .font(.title.bold())
            
            VStack(alignment: .leading) {
                DetailRow(icon: "envelope", text: client.email)
                DetailRow(icon: "phone", text: client.phoneNumber)
                if let address = client.address {
                    DetailRow(icon: "house", text: address)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.1), radius: 5)
            )
        }
    }
    
    private var realgamesTab: some View {
        VStack {
            if vm.realgames.isEmpty {
                emptyState(message: "Aucun jeu associé")
                    .frame(maxHeight: .infinity) // Remplit l'espace disponible
            } else {
                ScrollView { // Double défilement imbriqué
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(vm.realgames) { game in
                            GameCard(game: game)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var financialTab: some View {
        ScrollView { // Défilement pour les données financières
            VStack(spacing: 20) {
                FinancialCard(title: "Dû", amount: vm.due, color: .red)
                FinancialCard(title: "Retiré", amount: vm.withdrawn, color: .green)
            }
            .padding(.horizontal)
        }
    }
    
    private func emptyState(message: String) -> some View {
        VStack {
            Image(systemName: "gamecontroller")
                .font(.largeTitle)
            Text(message)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Composants réutilisables
struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            Text(text)
            Spacer()
        }
    }
}

struct GameCard: View {
    let game: Realgame
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.headline)
            
            Text(game.editor)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("\(game.unitPrice, specifier: "%.2f") €")
                    .font(.caption)
                
                Spacer()
                
                StatusBadge(status: game.status)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 3)
        )
    }
}

struct FinancialCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "eurosign.circle")
            }
            
            Text(amount.formatted(.currency(code: "EUR")))
                .font(.title.bold())
                .foregroundColor(color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.1), color.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: color.opacity(0.1), radius: 5)
        )
    }
}

struct StatusBadge: View {
    let status: Status
    
    var color: Color {
        switch status {
        case .stock: return .green
        case .towithdraw: return .orange
        case .sold: return .red
        case .withdrawn: return .gray
        }
    }
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .padding(5)
            .background(Capsule().fill(color.opacity(0.2)))
            .foregroundColor(color)
    }
}
