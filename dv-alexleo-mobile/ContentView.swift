//
//  ContentView.swift
//  depot-vente-frontend-mobile
//
//  Created by etud on 06/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    var body: some View {
        ZStack{
            
        TabView(selection: $selectedSideMenuTab) {
            HomeView(presentSideMenu: $presentSideMenu)
                .tag(0)
            LoginGestionView(presentSideMenu: $presentSideMenu)
                .tag(1)
            AdminView(presentSideMenu: $presentSideMenu)
                .tag(2)
        }
        
        SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
