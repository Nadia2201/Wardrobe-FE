//
//  ContentView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 23/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = true
    var body: some View {
        TabView {
                DashboardView()
                    .tabItem {
                        Image(systemName: "square")
                        Text("Dashboard")
                    }
                WardrobeView()
                    .tabItem {
                        Image(systemName: "hanger")
                        Text("My wardrobe")
                    }
                DisplayOutfits()
                    .tabItem {
                        Image(systemName: "tshirt")
                        Text("My outfits")
                    }
                AddItemView()
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Add an item")
                    }
                FavouritesView()
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Favourites")
                    }
                LoginView()
                    .tabItem {
                        Image(systemName: "door.left.hand.open")
                        Text("Logout")
                    }
                    .onTapGesture {
                    // Delete the token and log out
                    UserDefaults.standard.removeObject(forKey: "token")
                    isLoggedIn = false
                    }
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
