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
        .onAppear{
            viewModel.fetchCurrentSession()
        }
    }
}

struct SessionDetailView: View {
    let session: Session
    @ObservedObject var viewModel: SessionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session en cours")
                .font(.title)
            
            Text("Début : \(session.beginDate.formatted())")
            Text("Fin : \(session.endDate.formatted())")
            Text("Commission : \(session.commission, specifier: "%.1f")%")
            Text("Frais : \(session.fees , specifier: "%.1f")%")
            
            Button("Supprimer la session") {
                Task {
                   
                    await viewModel.deleteSession()
                    
                }
            }
            .foregroundColor(.red)
        }
    }
}

struct CreateSessionView: View {
    @ObservedObject var viewModel : SessionViewModel
    @State private var beginDate = Date()
    @State private var endDate = Date()
    @State private var commission = 10
    @State private var fees = 5
    
    var body: some View {
        Form {
            DatePicker("Date de début", selection: $beginDate)
            DatePicker("Date de fin", selection: $endDate)
            
            TextField("Commission (%)", value: $commission, format: .number)
                .keyboardType(.numberPad)
            
            TextField("Frais (%)", value: $fees, format: .number)
                .keyboardType(.numberPad)
            
            Button {
                Task {
                    await viewModel.createSession(
                        beginDate: beginDate,
                        endDate: endDate,
                        commission: Double(commission),
                        fees: Double(fees)
                    )
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Créer la session")
                }
            }
            .disabled(viewModel.isLoading)
        }
        .alert("Erreur",
               isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
