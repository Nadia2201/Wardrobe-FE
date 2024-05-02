//
//  OutfitServiceProtocol.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 30/04/2024.
//

import Foundation



public protocol OutfitServiceProtocol {
    func fetchOutfitCreated(completion: @escaping (Outfit?) -> Void) -> Void
    func createOutfitByTag(occasion: String, weather: String) async throws -> Outfit
    func createOutfitManually(top: String, bottom: String, shoes: String) async throws -> Void
}
