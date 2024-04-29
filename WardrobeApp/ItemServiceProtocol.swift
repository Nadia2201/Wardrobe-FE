//
//  ItemServiceProtocol.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 25/04/2024.
//

import UIKit

public protocol ItemServiceProtocol {
    func fetchItems(completion: @escaping ([Item]) -> Void) -> Void
    func createItem(name: String, category: String, image: String, tags: [String]) async throws -> Void
}
