
import SwiftUI

struct GestionView: View {
    @State private var selectedIndex: Int = 0
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Button{
                        presentSideMenu.toggle()
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            
            TabView(selection: $selectedIndex) {
                // Sales Tab
                NavigationStack {
                    SalesView()
                        .navigationTitle("Sales")
                }
                .tabItem {
                    Label("Sales", systemImage: "dollarsign.circle")
                }
                .tag(0)
                
                // Deposit Tab
                NavigationStack {
                    DepositView()
                        .navigationTitle("Deposit")
                }
                .tabItem {
                    Label("Deposit", systemImage: "arrow.down.circle")
                }
                .tag(1)
                
                // Treasury Tab
                NavigationStack {
                    TreasuryView()
                        .navigationTitle("Treasury")
                }
                .tabItem {
                    Label("Treasury", systemImage: "briefcase")
                }
                .tag(2)
                
                // Sellers Info Tab
                NavigationStack {
                    SellersInfoView()
                        .navigationTitle("Sellers Info")
                }
                .tabItem {
                    Label("Sellers", systemImage: "person.3")
                }
                .tag(3)
                
                // Stocks Tab
                NavigationStack {
                    StocksView()
                        .navigationTitle("Stocks")
                }
                .tabItem {
                    Label("Stocks", systemImage: "chart.bar")
                }
                .tag(4)
                
                // Transactions Tab
                NavigationStack {
                    TransactionsView()
                        .navigationTitle("Transactions")
                }
                .tabItem {
                    Label("Transactions", systemImage: "arrow.left.arrow.right")
                }
                .tag(5)
            }
            .accentColor(.orange)
        }
    }
}


struct SalesView: View { var body: some View { Text("Sales Content") } }
struct DepositView: View { var body: some View { Text("Deposit Content") } }
struct TreasuryView: View { var body: some View { Text("Treasury Content") } }
struct SellersInfoView: View { var body: some View { Text("Sellers Info") } }
struct StocksView: View { var body: some View { Text("Stocks Content") } }
struct TransactionsView: View { var body: some View { Text("Transactions Content") } }
