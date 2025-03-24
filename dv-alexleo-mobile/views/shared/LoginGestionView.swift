import SwiftUI

struct LoginGestionView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var navigationPath = NavigationPath() // Chemin de navigation
    
    @Binding var presentSideMenu: Bool
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
                
                VStack {
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
                    
                    Spacer()
                    
                    VStack {
                        TextField(
                            "utilisateur",
                            text: $viewModel.email
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.top, 20)
                        
                        Divider()
                        
                        SecureField(
                            "Mot de Passe",
                            text: $viewModel.password
                        )
                        .textContentType(.password)
                        .padding(.top, 20)
                        
                        Divider()
                    }
                    
                    Spacer()
                    
                    Button("Se connecter") {
                        viewModel.login { success in
                            if success {
                                // Ajoutez la destination à la pile de navigation
                                navigationPath.append("HomepageView")
                            }
                        }
                    }
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 24)
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "HomepageView" {
                    HomepageView(presentSideMenu: $presentSideMenu)
                }
            }
        }
    }
}
