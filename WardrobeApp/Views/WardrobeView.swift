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
//    @State private var currentIsFavouriteID: String?
//    @State private var favouriteItemIDs: Set<String> = [] // State to track favorited item IDs
    
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
                    FavouriteItem(itemID: item.id, currentIsFavouriteID: .constant(item.favourite ? item.id : nil), itemService: itemService)
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
//#Preview {
//    WardrobeView()
//}

//viewModel.fetchItems() //fetch items when the view appears
// When items are fetched, update the set of favorite item IDs
/*favouriteItemIDs = Set(viewModel.items.filter { $0.favourite }.map { $0.id })*/ // Set containing favorited item IDs

//struct WardrobeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WardrobeView()
//        }
//    }


//struct WardrobeView: View {
//    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes
//
//    @State private var currentIsFavouriteID: UUID?
//
//    var body: some View {
////        List(selection: viewModel.items){
////            item in
////
////            VStack(alignment: .leading) {
////                Text("Name: \(item.name)")
////                Text("Category: \(item.category)")
////                Text("Tags: \(item.tags.joined(separator: ", "))")
////                FavouriteItem(itemID: item.id, currentIsFavouriteID: $currentIsFavouriteID)
////            }
////        }
//
//
////        List(selection: $viewModel.items) { item in
////            HStack {
////                if let uiImage = displayImage(base64String: item.image) {
////
////                    //convert the image which is a string into a UIimage
////                    Image(uiImage: item.Image)
////                        .resizable()
////                        .scaledToFit()
////                        .frame(width: 50, height: 50)
////                }
////                VStack(alignment: .leading) {
////                    Text("Name: \(item.name)")
////                    Text("Category: \(item.category)")
////                    Text("Tags: \(item.tags.joined(separator: ", "))")
////                    FavouriteItem(itemID: item.id, currentIsFavouriteID: $currentIsFavouriteID)
////                }
////
////
////            }
////        }
//
//        .onAppear {
//            viewModel.fetchItems() //fetch items when the view appears
//
//        }
//    }
//    //}
//}
//

//struct FavouriteItem: View {
//    let itemID: String
//    @Binding var currentIsFavouriteID: [(String, Bool)] = []
//    // favourites should be an array
//    // if the item id is in the array then heart should be filled
//    var body: some View {
//        Button(action: {
//            if currentIsFavouriteID.contains(where: <#T##((String, Bool)) throws -> Bool#>) {
//                currentIsFavouriteID = nil
//            } else {
//                currentIsFavouriteID = itemID
//            }
//        }) {
//            Image(systemName: currentIsFavouriteID == itemID ? "heart.fill" : "heart")
//                .foregroundColor(currentIsFavouriteID == itemID ? .red : .gray)
//                            .padding()
//        }
//    }
//
//}

//                    FavouriteItem(itemID: item.id, currentIsFavouriteID: $currentIsFavouriteID, itemService: itemService)
