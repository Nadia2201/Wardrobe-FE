//
//  Outfit.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 30/04/2024.
//

import Foundation

public struct Outfit: Decodable, Identifiable {
    public let id: String //unique identifier
    var top: String
    var bottom : String?
    var shoes: String
    var favourite: Bool
    var createdAt: Date
    
    
    private enum CodingKeys: String, CodingKey {
        case top
        case bottom
        case shoes
        case favourite
        case createdAt
        case id
        
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        top = try container.decode(String.self, forKey: .top)
        bottom = try container.decode(String.self, forKey: .bottom)
        shoes = try container.decode(String.self, forKey: .shoes)
        favourite = try container.decode(Bool.self, forKey: .favourite)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        id = try container.decode(String.self, forKey: .id)
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        createdAt = dateFormatter.date(from: dateString) ?? Date()
    }
}
