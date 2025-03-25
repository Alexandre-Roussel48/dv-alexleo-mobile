//
//  AdminView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

import SwiftUI

struct AdminView: View {
    @State private var selectedIndex: Int = 0
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        VStack{
            Group {
                if authViewModel.isAuthenticated {
                    TabView(selection: $selectedIndex) {
                        GameView()
                            .navigationTitle("Games")
                            .tabItem{(Label("Games",systemImage: "gamecontroller"))}
                            .tag(0)
                        
                        ClientView()
                            .navigationTitle("Clients")
                            .tabItem{(Label("Clients",systemImage: "person.3"))}
                            .tag(1)
                        
                        SessionView()
                            .navigationTitle("Session")
                            .tabItem{(Label("Session",systemImage: "calendar"))}
                            .tag(2)
                    }.accentColor(.orange)
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
