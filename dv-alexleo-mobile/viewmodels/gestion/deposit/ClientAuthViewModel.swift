//
//  ClientAuthViewModel.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//


//
//  ClientAuthViewModel.swift
//  depot-vente-frontend-mobile
//
//  Created by alexandre.roussel03 on 23/03/2025.
//
import Foundation
import Combine

@MainActor
class ClientAuthViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var email = "" {
        didSet { fetchMatchingClients() }
    }
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var isRegistering = false
    
    @Published var matchingClients: [Client] = []
    @Published var selectedClient: Client?
    
    private let depositService = DepositService()
    private var searchCancellable: AnyCancellable?
    private var debounceTimer: Timer?

    // MARK: - Register a client
    func registerClient() async {
        let registration = ClientRegistration(
            name: name,
            surname: surname,
            email: email,
            phoneNumber: phoneNumber,
            address: address
        )
        
        do {
            let client = try await depositService.createClient(client: registration)
            selectedClient = client
        } catch {
            print("Registration error: \(error)")
        }
    }

    // MARK: - Fetch matching clients
    private func fetchMatchingClients() {
        debounceTimer?.invalidate()
        guard !email.isEmpty else {
            matchingClients = []
            return
        }
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            Task {
                await self?.searchClients()
            }
        }
    }

    private func searchClients() async {
        do {
            let results = try await depositService.getClient(email: email)
            matchingClients = results
        } catch {
            matchingClients = []
            print("Fetch error: \(error)")
        }
    }
    
    func toggleMode() {
        isRegistering.toggle()
    }
}
