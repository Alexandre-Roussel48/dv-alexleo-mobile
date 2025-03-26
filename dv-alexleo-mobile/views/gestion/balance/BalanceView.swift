import SwiftUI

struct BalanceDashboardView: View {
    @StateObject private var viewModel = BalanceViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DashboardHeader()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    MetricCard(
                        title: "Frais de dépôt",
                        value: viewModel.depositFees,
                        color: .blue,
                        icon: "eurosign.circle",
                        systemImage: true
                    )
                    
                    MetricCard(
                        title: "Commissions",
                        value: viewModel.commissions,
                        color: .green,
                        icon: "percent",
                        systemImage: true
                    )
                    
                    MetricCard(
                        title: "Dettes",
                        value: viewModel.dues,
                        color: .red,
                        icon: "exclamationmark.triangle",
                        systemImage: true
                    )
                    
                    MetricCard(
                        title: "Payé",
                        value: viewModel.paid,
                        color: .purple,
                        icon: "checkmark.circle",
                        systemImage: true
                    )
                    
                    MetricCard(
                        title: "Trésorerie",
                        value: viewModel.treasury,
                        color: .orange,
                        icon: "banknote",
                        systemImage: true
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Bilan Financier")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                RefreshButton(action: viewModel.fetchAllMetrics)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        .alert("Erreur", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            await viewModel.fetchAllMetrics()
        }
    }
}

// Composants réutilisables

struct DashboardHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Statistiques Financières")
                .font(.title2.bold())
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 20)
    }
}

struct MetricCard: View {
    let title: String
    let value: Int
    let color: Color
    let icon: String
    var systemImage: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Group {
                    if systemImage {
                        Image(systemName: icon)
                    } else {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                
                Spacer()
                
                Text("\(value) €")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(color.gradient)
        .cornerRadius(15)
        .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct RefreshButton: View {
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .symbolRenderingMode(.hierarchical)
        }
    }
}
