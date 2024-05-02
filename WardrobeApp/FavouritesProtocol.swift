//
//  FavouritesProtocol.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 01/05/2024.
//

import Foundation

public protocol FavouritesProtocol {
    func fetchFavourites(completion: @escaping ([Item]) -> Void) -> Void
    
}
