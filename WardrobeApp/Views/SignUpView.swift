//
//  SignUpView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 24/04/2024.
//

import SwiftUI

struct SignUpView: View {
  @State private var user = User(email: "", password: "", username: "")
  @State private var signUpError: Error? = nil
  @State private var isSignedUp = false
  var body: some View {
    NavigationView {
      VStack {
        Image("StyleSyncLogo")
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300)
          .accessibilityIdentifier("style-sync-logo")
          
        TextField("Email", text: $user.email)
          .padding()
          .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        SecureField("Password", text: $user.password)
          .padding()
          .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        TextField("Username", text: $user.username)
          .padding()
          .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    
        Button("Sign Up") {
          Task {
            do {
                let authService = AuthenticationService()
                try await
                authService.signUp(user:user)
                isSignedUp = true
            } catch {
              signUpError = error
            }
          }
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .font(.headline)
        .cornerRadius(8)
        Spacer()
        if let error = signUpError {
          Text("Error: \(error.localizedDescription)")
        }
        NavigationLink(destination: LoginView(), isActive: $isSignedUp) {
          EmptyView()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
      }
      .navigationBarBackButtonHidden(true)
      .padding()
    }
    .navigationBarBackButtonHidden(true)
  }
}
struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}

