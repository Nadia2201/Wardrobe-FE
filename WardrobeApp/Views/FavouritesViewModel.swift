//
//  FavouritesViewModel.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 01/05/2024.
//

import SwiftUI


class FavouritesViewModel: ObservableObject {
    @Published var favourites: [Item] = []
    
    let itemService = ItemService() // Reference to the service that fetches items
        
    // Function to fetch favorite items
    func fetchFavoriteItems() {
        itemService.fetchItems { [weak self] fetchedItems in
            let favoriteItems = fetchedItems.filter { $0.favourite } // Apply the filter
            DispatchQueue.main.async { // Ensure changes occur on the main thread
                self?.favourites = favoriteItems // Update the published variable
            }
        }
    }
    
}
