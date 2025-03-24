import SwiftUI

struct HomeView: View {
    @Binding var presentSideMenu: Bool
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        VStack {
            // Header
            HStack {
                Button {
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Contenu principal
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                } else if let error = viewModel.errorMessage {
                    ErrorView(error: error)
                    
                } else if let session = viewModel.currentSession {
                    ActiveSessionView(session: session)
                    
                } else {
                    NoSessionView()
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// Sous-vues
private struct ActiveSessionView: View {
    let session: Session
    var body: some View {
        VStack(spacing: 20) {
            Text("Session en cours")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            SessionInfoRow(title: "Début", value: session.beginDate.formatted())
                       SessionInfoRow(title: "Fin", value: session.endDate.formatted())
                       SessionInfoRow(title: "Commission", value: "\(session.commission)%")
                       SessionInfoRow(title: "Frais", value: "\(session.fees) €")
            
            Button(action: {}) {
                            Text("Accéder à la session")
                                .sessionButtonStyle()
                        }
                    }
                    .padding(.bottom, 40)
        }
}

private struct NoSessionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
            
            Text("Aucune session active")
                .font(.title2)
            
            Text("Revenez ultérieurement pour voir les sessions programmées")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

extension Text {
    func sessionButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(10)
            .shadow(color: .red.opacity(0.4), radius: 5, y: 3)
    }
}

struct SessionInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}
