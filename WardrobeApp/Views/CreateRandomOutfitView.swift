//
//  CreateRandomOutfitView.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 01/05/2024.
//

import SwiftUI
import Foundation

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
        
    var body: some View {
        VStack {
            Image("StyleSyncLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .accessibilityIdentifier("style-sync-logo")
            Text("Outfit Generator")
                .font(.largeTitle).bold().italic()
                .padding()
            Spacer()
            
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
            .padding()
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
            
            // NavigationLink only when generatedOutfit is non-optional
            if let outfit = generatedOutfit { // Safe optional binding
                
//                NavigationLink(
//                    destination: DisplayOutfits(outfit: outfit), // Navigate to OutfitView
//                    isActive: $navigateToOutfit // Control navigation
//                ) {
//                    EmptyView() // Invisible NavigationLink
//                }
            }
        }
    }
}

#Preview {
    CreateRandomOutfitView()
}
