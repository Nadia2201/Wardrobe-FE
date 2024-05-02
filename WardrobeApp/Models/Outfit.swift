//
//  Outfit.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 30/04/2024.
//

import Foundation
import UIKit

public struct Outfit: Decodable, Identifiable {
    public let id: String //unique identifier
    public var top: String
    public var bottom : String
    public var shoes: String
    public var favourite: Bool
    public var createdAt: Date
    
    public init(id: String, top: String, bottom: String, shoes: String, favourite: Bool, createdAt: Date) {
            self.id = id
            self.top = top
            self.bottom = bottom
            self.shoes = shoes
            self.favourite = favourite
            self.createdAt = createdAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case top
        case bottom
        case shoes
        case favourite
        case createdAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id =        try container.decode(String.self, forKey: .id)
        top =       try container.decode(String.self, forKey: .top)
        shoes =     try container.decode(String.self, forKey: .shoes)
        bottom =    try container.decode(String.self, forKey: .bottom)
        
//        createdAt = try container.decode(Date.self, forKey: .createdAt)
        favourite = (try? container.decode(Bool.self, forKey: .favourite)) ?? false
        
        // Corrected date decoding with ISO 8601 strategy
        let dateString = try container.decode(String.self, forKey: .createdAt)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Use ISO 8601 format
        
        createdAt = dateFormatter.date(from: dateString) ?? Date() // Correctly parse date string
        
//        let dateString = try? container.decode(String.self, forKey: .createdAt)
//        
//        if (dateString != nil) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//            createdAt = dateFormatter.date(from: dateString!) ?? Date()
//        }
        
    }
    
    
    
}
