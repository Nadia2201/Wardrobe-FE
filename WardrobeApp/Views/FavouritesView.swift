//
//  FavouritesView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 29/04/2024.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel = FavouritesViewModel() // ObservedObject to track changes
    
        var body: some View {
            ScrollView {
                VStack { // Added VStack for multiple components
                    // Display the StyleSyncLogo
                    Image("StyleSyncLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .accessibilityIdentifier("style-sync-logo") // For accessibility testing
                    
                    Text("Your Favourites")
                        .font(.largeTitle)
                        .italic()
                    Spacer() // Add space between components
                    
                    // List of favorite items
                    ForEach(viewModel.favourites) { item in
                        HStack {
                            if let uiImage = item.uiImage { // Display the image
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50) // Adjust size
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Name: \(item.name)") // Display item information
                                Text("Category: \(item.category)")
                                Text("Tags: \(item.tags.joined(separator: ", "))")
                            }
                        }
                        .padding() // Add padding for better spacing
                    }
                }
            }
            .onAppear {
                viewModel.fetchFavoriteItems()
            }
        }
    }
#Preview {
    FavouritesView()
}
