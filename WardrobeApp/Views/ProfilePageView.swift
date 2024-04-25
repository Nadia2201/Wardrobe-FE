//
//  ProfilePageView.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 25/04/2024.
//

import SwiftUI

struct ProfilePageView: View {
    
    @State private var shouldNavigateToLogIn = false
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    VStack {
                        // Add spacer to push content down from the top
                        Spacer().frame(height: 100)
                            .toolbar {
                                ToolbarItem(placement: .navigation) {
                                    Image("StyleSyncLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 200)
                                        .accessibilityIdentifier("style-sync-logo")
                                }
                                
                                    }
//                            Spacer()
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(radius: 10)
                            

                        Spacer() // Keeps the profile image at the top and allows content below it to be flexible
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Text("User")
                        .font(.largeTitle)
                    
                
                        }
                    }
                }
            }


#Preview {
    ProfilePageView()
}


//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Menu {
//                            Button(action: {
//                                shouldNavigateToLogIn = true
//                            }) {
//                                List {
//                                Label("Sign Out", systemImage: "person.crop.circle")
////                                Label("Delete Account", systemImage: "person.crop.circle")
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis.circle")
//                .background(
//                    NavigationLink(
//                        destination: LoginView(authService: AuthenticationService()),
//                        isActive: $shouldNavigateToLogIn,
                        
//                    )
            
//
