
import SwiftUI

struct GestionView: View {
    @State private var selectedIndex: Int = 0
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack{
            Group {
                if authViewModel.isAuthenticated {
                    TabView(selection: $selectedIndex) {
                        SalesView()
                            .navigationTitle("Sales")
                            .tabItem { Label("Sales", systemImage: "dollarsign.circle") }
                            .tag(0)
                        
                        DepositView()
                            .navigationTitle("Deposit")
                            .tabItem { Label("Deposit", systemImage: "arrow.down.circle") }
                            .tag(1)

                        TreasuryView()
                            .navigationTitle("Treasury")
                            .tabItem { Label("Treasury", systemImage: "briefcase") }
                            .tag(2)

                        SellersInfoView()
                            .navigationTitle("Sellers Info")
                            .tabItem { Label("Sellers", systemImage: "person.3") }
                            .tag(3)

                        StocksView()
                            .navigationTitle("Stocks")
                            .tabItem { Label("Stocks", systemImage: "chart.bar") }
                            .tag(4)

                        TransactionsView()
                            .navigationTitle("Transactions")
                            .tabItem { Label("Transactions", systemImage: "arrow.left.arrow.right") }
                            .tag(5)
                    }
                    .accentColor(.orange)
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}


struct SalesView: View { var body: some View { Text("Sales Content") } }
struct TreasuryView: View { var body: some View { Text("Treasury Content") } }
struct SellersInfoView: View { var body: some View { Text("Sellers Info") } }
struct StocksView: View { var body: some View { Text("Stocks Content") } }
struct TransactionsView: View { var body: some View { Text("Transactions Content") } }
