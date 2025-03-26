
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

                        BalanceDashboardView()
                            .navigationTitle("Balance")
                            .tabItem { Label("Balance", systemImage: "briefcase") }
                            .tag(2)

                        ClientSearchView()
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
struct StocksView: View { var body: some View { Text("Stocks Content") } }
struct TransactionsView: View { var body: some View { Text("Transactions Content") } }
