import SwiftUI

struct SessionView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showCreateSession = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text("Erreur : \(error)")
                    .foregroundColor(.red)
            } else if let session = viewModel.currentSession {
                SessionDetailView(session: session, viewModel: viewModel)
            } else {
                Button("Créer une session") {
                    showCreateSession = true
                }
                .sheet(isPresented: $showCreateSession) {
                    CreateSessionView(viewModel: viewModel)
                }
            }
        }
        .padding()
        .navigationTitle("Gestion des sessions")
    }
}

struct SessionDetailView: View {
    let session: Session
    @ObservedObject var viewModel: SessionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session en cours")
                .font(.title)
            
            Text("Début : \(session.begin_date.formatted())")
            Text("Fin : \(session.end_date.formatted())")
            Text("Commission : \(session.commission)%")
            Text("Frais : \(session.fees)€")
            
            Button("Supprimer la session") {
                viewModel.deleteSession(id: session.id)
            }
            .foregroundColor(.red)
        }
    }
}

struct CreateSessionView: View {
    @ObservedObject var viewModel: SessionViewModel
    @State private var beginDate = Date()
    @State private var endDate = Date()
    @State private var commission = 10
    @State private var fees = 5
    
    var body: some View {
        Form {
            DatePicker("Date de début", selection: $beginDate)
            DatePicker("Date de fin", selection: $endDate)
            Stepper("Commission : \(commission)%", value: $commission, in: 0...100)
            Stepper("Frais : \(fees)€", value: $fees, in: 0...100)
            
            Button("Créer") {
                viewModel.createSession(beginDate: beginDate, endDate: endDate, commission: commission, fees: fees)
            }
        }
        .navigationTitle("Nouvelle session")
    }
}
