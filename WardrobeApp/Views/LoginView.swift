//
//  LoginView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 24/04/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var user = User(email: "", password: "", username: "")
    @State private var token: String? = nil
    @State private var errorMessage: String? = nil
    @State private var loggedIn: Bool = false // Track login status
    
    var body: some View {
        NavigationView {
            VStack {
              
                
                Spacer()
                Image("StyleSyncLogo")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 300, height: 300)
                  .accessibilityIdentifier("style-sync-logo")
                Spacer()
                TextField("Email", text: $user.email)
                    .padding()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                SecureField("Password", text: $user.password)
                    .padding()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                Spacer()
                Spacer()
                Button("Login") {
                    Task {
                        let service = AuthenticationService()
                        await service.login(user: user) { result in
                            switch result {
                            case .success(let token):
                                self.token = token
                                self.loggedIn = true 
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(8)
                NavigationLink(destination: DashboardView(), isActive: $loggedIn) {
                    EmptyView()
                }
                .hidden()
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
