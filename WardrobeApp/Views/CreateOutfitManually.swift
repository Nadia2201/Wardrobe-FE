//
//  CreateOutfitManually.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 02/05/2024.
//

import SwiftUI
import UIKit


// Utility function to convert base64 to UIImage
func displayImage2(base64String: String) -> UIImage? {
    if let imageData = Data(base64Encoded: base64String) {
        return UIImage(data: imageData) // Return UIImage from data
    }
    return nil // Return nil if decoding fails
}

struct FavouriteItem2: View {
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

struct CreateOutfitManually: View {
    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes
    @State private var selectedItems: [String: Item] = [:]
    @State private var navigationLinkTag: String? = nil
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let itemService = ItemService() // Initialize the service
    let outfitService = OutfitService()
    
    var body: some View {
        VStack {
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
                    }
                    Spacer()
                    Toggle("", isOn: Binding<Bool>(
                        get: { selectedItems[item.id] != nil },
                        set: { if $0 { selectedItems[item.id] = item } else { selectedItems[item.id] = nil } }
                    ))
                    .padding(.trailing)
                    .labelsHidden()
                    
                    FavouriteItem(itemID: item.id, currentIsFavouriteID: .constant(item.favourite ? item.id : nil), itemService: itemService, refreshAction: {
                        viewModel.fetchItems() // Refresh items after update
                    })
                }
            }
            
            Button(action: createOutfit) {
                Text("Generate my outfit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(selectedItems.count != 3)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Outfit Added"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear{
            Task {
                await viewModel.fetchItems()
            }
        }
    }
    
    func createOutfit() {
        Task {
             let selectedTops = selectedItems.values.filter { $0.category == "top" }
             let selectedBottoms = selectedItems.values.filter { $0.category == "bottom" }
             let selectedShoes = selectedItems.values.filter { $0.category == "shoes" }
             
             print("Selected tops count: \(selectedTops.count)")
             print("Selected bottoms count: \(selectedBottoms.count)")
             print("Selected shoes count: \(selectedShoes.count)")
             
             guard selectedTops.count == 1, selectedBottoms.count == 1, selectedShoes.count == 1 else {
                 print("Please select exactly one top, one bottom, and one pair of shoes.")
                 return
             }
             
             guard let top = selectedTops.first,
                   let bottom = selectedBottoms.first,
                   let shoes = selectedShoes.first else {
                 print("Please select exactly one top, one bottom, and one pair of shoes.")
                 return
             }
             
             do {
                 try await outfitService.createOutfitManually(top: top.id, bottom: bottom.id, shoes: shoes.id)
                 print("Outfit created successfully.")
                 // Pass top, bottom, and shoes IDs to OutfitView
                 showingAlert = true
                 alertMessage = "Added to your Outfits"
                 navigationLinkTag = UUID().uuidString
             } catch {
                 print("Error creating outfit manually: \(error)")
             }
         }
     }
    func createOutfitManually(top: Item, bottom: Item?, shoes: Item) async throws {
        let topID = top.id
        let bottomID = bottom?.id ?? ""
        let shoesID = shoes.id
        do {
            try await outfitService.createOutfitManually(top: topID, bottom: bottomID, shoes: shoesID)
            print("Outfit created successfully.")
//            showingAlert = true
//            alertMessage = "Your new outfit has been added to your wardrobe"
        } catch {
            throw error
        }
    }
}

struct CreateOutfitManually_Previews: PreviewProvider {
    static var previews: some View {
        CreateOutfitManually()
    }
}



