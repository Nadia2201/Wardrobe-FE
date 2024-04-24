//
//  HomePageView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 24/04/2024.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView{
        ZStack {
            VStack {
                Spacer()

                Text("Welcome!")
                            .font(.title)

                Spacer()

                Image("StyleSyncLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .accessibilityIdentifier("StyleSyncLogo")
                
                Spacer()
            
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                            .accessibilityIdentifier("signUpButton")
                        
                    }
                    .navigationBarBackButtonHidden(true)
                Spacer()
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                            .accessibilityIdentifier("loginButton")
                    }
                    .navigationBarBackButtonHidden(true)
                
                Spacer()
                
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
