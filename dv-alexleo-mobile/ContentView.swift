//
//  ContentView.swift
//  depot-vente-frontend-mobile
//
//  Created by etud on 06/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var presentSideMenu = false
    @State private var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack {
            // Main Content
            TabView(selection: $selectedSideMenuTab) {
                ScreenWrapper(presentSideMenu: $presentSideMenu) {
                    HomeView()
                }
                .tag(0)

                ScreenWrapper(presentSideMenu: $presentSideMenu) {
                    GestionView()
                }
                .tag(1)

                ScreenWrapper(presentSideMenu: $presentSideMenu) {
                    AdminView()
                }
                .tag(2)
            }
            .disabled(presentSideMenu) // prevent interactions when menu is open
            .blur(radius: presentSideMenu ? 5 : 0)
            .animation(.easeInOut(duration: 0.25), value: presentSideMenu)

            // Background overlay
            if presentSideMenu {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            presentSideMenu = false
                        }
                    }
            }

            // Side Menu
            SideMenu(
                isShowing: $presentSideMenu,
                content: AnyView(
                    SideMenuView(
                        selectedSideMenuTab: $selectedSideMenuTab,
                        presentSideMenu: $presentSideMenu
                    )
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
