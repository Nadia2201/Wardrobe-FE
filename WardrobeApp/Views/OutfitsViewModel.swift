//
//  OutfitsViewModel.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 01/05/2024.
//

import Foundation
import Combine

class OutfitsViewModel: ObservableObject {
    @Published var outfits: [Outfit] = [] // observable property to update SwiftUI view
    private let outfitService = OutfitService.shared

    init() {
        fetchOutfitCreated()
    }

    func fetchOutfitCreated() {
        outfitService.fetchOutfitCreated { [weak self] fetchedOutfit in
            DispatchQueue.main.async {
                if let outfit = fetchedOutfit {
                    self?.outfits.append(outfit)
                }
            }
        }
    }
}
