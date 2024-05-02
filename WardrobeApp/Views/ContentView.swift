//
//  ContentView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 23/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = true
   
    let defaultOutfit = Outfit(
            id: "12345",
            top: "Sample Top",
            bottom: "Sample Bottom",
            shoes: "Sample Shoes",
            favourite: true,
            createdAt: Date() // Provide a valid Date
        )
    
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
            DisplayOutfits(outfit: defaultOutfit)
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
                HomePageView()
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
