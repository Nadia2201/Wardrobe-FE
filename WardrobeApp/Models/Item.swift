//
//  Item.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 25/04/2024.
//

import Foundation
import UIKit

public struct Item: Decodable, Identifiable {
    public let id: String //unique identifier
    var name: String
    var category: String
    var tags: [String]
    var image: String
    var favourite: Bool
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case category
        case tags
        case image
        case id
        case favourite
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        tags = try container.decode([String].self, forKey: .tags)
        image = try container.decode(String.self, forKey: .image)
        id = try container.decode(String.self, forKey: .id)
        favourite = (try? container.decode(Bool.self, forKey: .favourite)) ?? false
    }
    
    public var uiImage: UIImage? {
        guard let imageData = Data(base64Encoded: image) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
