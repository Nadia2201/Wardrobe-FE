//
//  ItemsViewModel.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 27/04/2024.
//

import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = [] // observable property to update SwiftUI view
    private let itemService = ItemService.shared
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        itemService.fetchItems { [weak self] fetchedItems in
            DispatchQueue.main.async {
                self?.items = fetchedItems
            }
        }
    }
}
