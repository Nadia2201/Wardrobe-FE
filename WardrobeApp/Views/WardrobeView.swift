//
//  WardrobeView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 29/04/2024.
//

import SwiftUI
import UIKit


// Utility function to convert base64 to UIImage
func displayImage(base64String: String) -> UIImage? {
    if let imageData = Data(base64Encoded: base64String) {
        return UIImage(data: imageData) // Return UIImage from data
    }
    return nil // Return nil if decoding fails
}

struct FavouriteItem: View {
    let itemID: String
    @Binding var currentIsFavouriteID: String?
    var itemService: ItemService // Service to send the request to the backend
    var refreshAction: () -> Void

    // favourites should be an array
    // if the item id is in the array then heart should be filled
    var body: some View {
        Button(action: {
            if currentIsFavouriteID == itemID {
                currentIsFavouriteID = ""
                Task {
                    
                        do {
                            // Send the update to the backend
                            try await itemService.favouriteItem(itemID: itemID, isFavourite: false)
                            refreshAction()
                        } catch {
                            print("Error sending favorite update:", error)
                        }
                    }
                } else {
                    currentIsFavouriteID = itemID
                    Task {
                        do {
                            // Send the update to the backend
                            try await itemService.favouriteItem(itemID: itemID, isFavourite: true)
                            refreshAction()
                        } catch {
                            print("Error sending favorite update:", error)
                        }
                    }
                }
            
        }) {
            Image(systemName: currentIsFavouriteID == itemID ? "heart.fill" : "heart")
                .foregroundColor(currentIsFavouriteID == itemID ? .red : .gray)
                .padding()
        }
    }
}

struct WardrobeView: View {
    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes
    
    
    let itemService = ItemService() // Initialize the service
    
    var body: some View {
        List(viewModel.items) { item in
            HStack {
                if let image = item.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50) //adjust as needed
                }
                VStack(alignment: .leading) {
                    Text("Name: \(item.name)")
                    Text("Category: \(item.category)")
                    Text("Tags: \(item.tags.joined(separator: ", "))")

                    // Pass the correct Binding and ItemService to FavouriteItem
                    FavouriteItem(itemID: item.id, currentIsFavouriteID: .constant(item.favourite ? item.id : nil), itemService: itemService, refreshAction: {
                        viewModel.fetchItems() // Refresh items after update
                    })
                }
            }
        }
        .onAppear{
            viewModel.fetchItems()
        }
    }
}

struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}




