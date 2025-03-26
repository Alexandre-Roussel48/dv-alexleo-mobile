
import SwiftUI

struct CatalogView: View {
    @StateObject var viewModel = CatalogViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading) {
                    Text("Prix")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    RangedSliderView(value: $viewModel.priceRange, bounds: 0...100)
                        .frame(height:50)
                        .frame(width: 300)
                        .onChange(of: viewModel.priceRange) { _ in
                            viewModel.fetchMatchingCatalog()
                        }
                    Text("De \(Int(viewModel.priceRange.lowerBound))€ à \(Int(viewModel.priceRange.upperBound))€")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    ErrorView(error: error)
                } else if viewModel.games.isEmpty {
                    Text("Aucun jeu trouvé")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.games) { game in
                                GameRow(game: game)
                                Divider()
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Catalogue")
            .searchable(text: $viewModel.searchText, prompt: "Rechercher un jeu")
            
        }
        
    }
}

struct GameRow: View {
    let game: CatalogItem
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
                Text(game.gameName.prefix(2).uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(game.gameName), \(game.gameEditor)")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("Vendu par \(game.sellerFullName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(String(format: "%.2f€", game.unitPrice))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

