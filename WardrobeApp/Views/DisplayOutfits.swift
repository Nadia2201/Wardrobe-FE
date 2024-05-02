//
//  DisplayOutfits.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 02/05/2024.
//

import SwiftUI

struct DisplayOutfits: View {
    @ObservedObject var viewModel = OutfitsViewModel() //observedObject to track changes
    
    
    let itemService = OutfitService() // Initialize the service
    
    var body: some View {
        List(viewModel.outfits) { outfit in
            HStack {
//                if let image = item.uiImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50) //adjust as needed
//                }
                VStack(alignment: .leading) {
                    Text("Top: \(outfit.top)")
                    Text("Bottom: \(outfit.bottom)")
                    Text("Shoes: \(outfit.shoes)")

                    // Pass the correct Binding and ItemService to FavouriteItem
//                    FavouriteItem(itemID: item.id, currentIsFavouriteID: .constant(item.favourite ? item.id : nil), itemService: itemService, refreshAction: {
//                        viewModel.fetchItems() // Refresh items after update
//                    })
                    
                }
            }
        }
        .onAppear{
            viewModel.fetchOutfitCreated()
        }
    }
}

struct DisplayOutfits_Previews: PreviewProvider {
    static var previews: some View {
        DisplayOutfits()
    }
}
