//
//  ContentView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 23/04/2024.
//

import SwiftUI

struct ContentView: View {
   
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
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
