//
//  SignUpView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 08/01/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var nome: String = ""
    @State private var senha: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome = false

    var body: some View {
        VStack {
            
                Spacer().frame(height: 80)
                
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 250) // Tamanho da imagem ajustado para iPhone 8
            
            Spacer().frame(height: 50)
            
            VStack(spacing: 8) { // Espaçamento reduzido entre os campos de texto
                TextField("Insira um Nome aqui", text: $nome)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Insira uma Senha aqui", text: $senha)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            
                
            Spacer().frame(height: 30)

            Button(action: {
                if validateNome(nome) && validateSenha(senha) {
                    self.navigateToHome = true
                } else {
                    self.showingAlert = true
                }
            }) {
                Text("Cadastrar")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Erro de Cadastro"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Entendi"))
                )
            }

            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "return.left")
                    .frame(width: 44, height: 44)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 8)

            Spacer()
        }
        .background(NavigationLink(destination: HomeView(), isActive: $navigateToHome) { EmptyView() })
        .navigationBarBackButtonHidden(true)
        .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
        .edgesIgnoringSafeArea(.all)
    }


    func validateNome(_ nome: String) -> Bool {
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        let nomeCharacterSet = CharacterSet(charactersIn: nome)
        if !nomeCharacterSet.isSubset(of: allowedCharacters) {
            alertMessage = "O nome deve conter apenas letras e espaços."
            return false
        }
        return true
    }

    func validateSenha(_ senha: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,25}$"
        if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: senha) {
            return true
        } else {
            alertMessage = "A senha deve ter entre 8 e 25 caracteres incluindo, pelo menos, uma maiúscula, um número e um símbolo."
            return false
        }
    }
}
