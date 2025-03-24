import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)

            VStack(spacing: 20) {
                Spacer()

                Text("Connexion")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)

                Text("Veuillez vous connecter pour accéder à l'application")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    TextField("Adresse e-mail", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)

                    SecureField("Mot de passe", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }

                    Button(action: {
                        viewModel.login { success in
                            if success {
                                viewModel.isAuthenticated = true
                            }
                        }
                    }) {
                        Text("Se connecter")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}
