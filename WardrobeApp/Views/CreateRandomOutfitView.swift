//
//  CreateRandomOutfitView.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 01/05/2024.
//

import SwiftUI
import Foundation
import UIKit

struct CreateRandomOutfitView: View {
    @State private var selectedCriteria: Set<String> = []
    let listOfCriteria = [
        ["title": "occasion", "listOfCriteria": ["casual", "smart", "sporty", "partywear"]],
        ["title": "weather", "listOfCriteria": ["summer", "winter", "rainy", "warm"]]
    ]
    
    @State private var selectedOccasion: String? // Selected option from Category
    @State private var selectedWeather: String? // Selected option from Type
    @State private var showAlert = false // State to manage alerts
    @State private var navigateToOutfit = false // State variable to control navigation
    @State private var generatedOutfit: Outfit? // The generated outfit
    @State private var topId = ""
    @State private var bottomId = ""
    @State private var shoesId = ""
    @State private var fetchedItem: Item?
    @State private var fetchedItemBottom: Item?
    @State private var fetchedItemShoes: Item?
    var body: some View {
        VStack {
//            Image("StyleSyncLogo")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 150, height: 150)
//                .accessibilityIdentifier("style-sync-logo")
//            Text("Outfit Generator")
//                .font(.title).bold().italic()
////                .padding()
//            Spacer()
            
            Text("Select tags to choose your outfit!")
                .font(.subheadline).bold()
            
            List {
                ForEach(0..<listOfCriteria.count) { index in
                    let criteria = listOfCriteria[index]
                    let sectionTitle = criteria["title"] as! String
                    let options = criteria["listOfCriteria"] as! [String]
                    
                    Section(header: Text(sectionTitle)) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                if sectionTitle == "occasion" {
                                    selectedOccasion = option
                                } else if sectionTitle == "weather" {
                                    selectedWeather = option
                                }
                            }) {
                                HStack {
                                    Text(option)
                                    
                                    // Determine which state to use based on the section
                                    let isSelected = (sectionTitle == "occasion" && selectedOccasion == option) ||
                                    (sectionTitle == "weather" && selectedWeather == option)
                                    
                                    // Display the correct icon for selected/unselected
                                    Image(systemName: isSelected ? "circle.fill" : "circle")
                                        .foregroundColor(isSelected ? .black : .gray) // Change color based on selection
                                    
                                }
                            }
                        }
                    }
                }
            }
//            .padding()
            Button("Generate Outfit") {
                if let occasion = selectedOccasion, let weather = selectedWeather, !occasion.isEmpty, !weather.isEmpty {
                    
                    Task {
                        do {
                            print(occasion, weather)
                            let outfitService = OutfitService()
                            
                            let outfit = try await outfitService.createOutfitByTag(
                                occasion: occasion,
                                weather: weather)
                            
                            generatedOutfit = outfit // Store the generated outfit
                            navigateToOutfit = true // Trigger navigation
                            topId = generatedOutfit?.top ?? ""
                            bottomId = generatedOutfit?.bottom ?? ""
                            shoesId = generatedOutfit?.shoes ?? ""
                            print(topId)
                            let service = OutfitService()
//                            try await service.fetchOutfitById(itemId: topId) { result in
//                                                switch result {
//                                                case .success(let item):
//                                                    print("Item fetched successfully:", item)
//                                                    fetchedItem = item
//                                                    print("this is the generated image:")
//                                                    print(fetchedItem?.image)
//                                                    if let fetchedItem = fetchedItem,
//                                                        let imageData = Data(base64Encoded: fetchedItem.image),
//                                                        let uiImage = UIImage(data: imageData) {
//                                                        Image(uiImage: uiImage)
//                                                            .resizable()
//                                                            .scaledToFit()
//                                                            .frame(width: 150, height: 150)
//                                                                }
//                                                case .failure(let error):
//                                                    print("Error fetching item:", error)
//                                                }
//                                            }
                            // Fetch top item
                            // Fetch top item
                                            try await outfitService.fetchOutfitById(itemId: topId) { result in
                                                switch result {
                                                case .success(let topItem):
                                                    fetchedItem = topItem
                                                case .failure(let error):
                                                    print("Error fetching top item:", error)
                                                }
                                            }
                                            
                                            // Fetch bottom item
                                            try await outfitService.fetchOutfitById(itemId: bottomId) { result in
                                                switch result {
                                                case .success(let bottomItem):
                                                    fetchedItemBottom = bottomItem
                                                case .failure(let error):
                                                    print("Error fetching bottom item:", error)
                                                }
                                            }
                                            
                                            // Fetch shoes item
                                            try await outfitService.fetchOutfitById(itemId: shoesId) { result in
                                                switch result {
                                                case .success(let shoesItem):
                                                    fetchedItemShoes = shoesItem
                                                case .failure(let error):
                                                    print("Error fetching shoes item:", error)
                                                }
                                            }
                                        } catch {
                                            print("Error generating outfit", error.localizedDescription)
                                        }
                                    }
                        } else {
                            showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Missing Information"),
                    message: Text("Please select both an occasion and a weather type before generating an outfit."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .disabled(selectedOccasion == nil || selectedWeather == nil || selectedOccasion!.isEmpty || selectedWeather!.isEmpty) // Disable the button if criteria are not met
            // Display the fetched image
            if let topItem = fetchedItem,
               let topImageData = Data(base64Encoded: topItem.image),
               let topUIImage = UIImage(data: topImageData),
               let bottomItem = fetchedItemBottom,
               let bottomImageData = Data(base64Encoded: bottomItem.image),
               let bottomUIImage = UIImage(data: bottomImageData),
               let shoesItem = fetchedItemShoes,
               let shoesImageData = Data(base64Encoded: shoesItem.image),
               let shoesUIImage = UIImage(data: shoesImageData) {
                VStack(spacing: 0) {
                    Image(uiImage: topUIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .padding(.bottom, 0)
                        .padding(.top, 0)
                    
                    Image(uiImage: bottomUIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .padding(.bottom, 0)
                        .padding(.top, 0)
                    
                    Image(uiImage: shoesUIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .padding(.bottom, 0)
                        .padding(.top, 0)
                }
            }
        }
    }
}

#Preview {
    CreateRandomOutfitView()
}
