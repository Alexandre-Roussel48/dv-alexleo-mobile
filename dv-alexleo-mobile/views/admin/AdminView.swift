//
//  AdminView.swift
//  dv-alexleo-mobile
//
//  Created by alexandre.roussel03 on 24/03/2025.
//

import SwiftUI

struct AdminView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack{
            TabView(selection: $selectedIndex) {
                NavigationStack {
                    Text("Jeux")
                        .navigationTitle("Games")
                }
                .tabItem {
                    Label("Jeux", systemImage: "gamecontroller")
                }
                .tag(0)
                
                NavigationStack {
                    Text("Utilisateurs")
                        .navigationTitle("Users")
                }
                .tabItem {
                    Label("Utilisateurs", systemImage: "person.3")
                }
                .tag(1)
                
                NavigationStack {
                    Text("Sessions")
                        .navigationTitle("Sessions")
                }
                .tabItem {
                    Label("Sessions", systemImage: "calendar")
                }
                .tag(2)
            }.accentColor(.orange)
        }
    }
}
