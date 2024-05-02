//
//  DisplayOutfits.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 02/05/2024.
//

import SwiftUI

struct DisplayOutfits: View {
    @ObservedObject var viewModel = OutfitsViewModel() //observedObject to track changes
    
    let outfit: Outfit // The outfit object with the details to display

    var body: some View {
        VStack(alignment: .leading) {
            Text("Top: \(outfit.top)")
            Text("Bottom: \(outfit.bottom)")
            Text("Shoes: \(outfit.shoes)")
        }
        
    }
}

// Date formatter for 'createdAt' field
private let outfitDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 date format
    return formatter
}()


struct DisplayOutfits_Previews: PreviewProvider {
    static var previews: some View {
        let sampleOutfit = Outfit(
        id: "12345",
        top: "T-shirt",
        bottom: "Jeans",
        shoes: "Sneakers",
        favourite: true,
        createdAt: Date()
        )
        
        DisplayOutfits(outfit: sampleOutfit)
    }
}
