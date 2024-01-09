import SwiftUI

struct LoginView: View {
    @State private var nome: String = ""
    @State private var senha: String = ""
    @State private var navigateToHome = false
    @State private var navigateToSignUp = false
    @State private var navigateAsGuest = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)
                
                Image("AppTitle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 70)

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 250)
                
                Spacer().frame(height: 15)
                
                VStack(spacing: 8) {
                    TextField("Nome", text: $nome)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Senha", text: $senha)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 30)

                Button("Login") {
                    self.navigateToHome = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                // NavigationLink é disparado pelo estado navigateToHome
                .background(
                    NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                        EmptyView()
                    }
                )

                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Button("Cadastre-se aqui") {
                            self.navigateToSignUp = true
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .background(
                            NavigationLink(destination: SignUpView(), isActive: $navigateToSignUp) {
                                EmptyView()
                            }
                        )

                        Button("Entrar como convidado") {
                            self.navigateAsGuest = true
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .background(
                            NavigationLink(destination: HomeView(), isActive: $navigateAsGuest) {
                                EmptyView()
                            }
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
