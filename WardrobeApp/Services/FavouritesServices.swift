//
//  FavouritesServices.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 01/05/2024.
//

import Foundation

class FavouritesService : FavouritesProtocol {
    
    // might need to add variables but dont know what
    
    
    static let shared = FavouritesService()

    func fetchFavourites(completion: @escaping ([Item]) -> Void) {
            guard let url = URL(string: "http://localhost:3000/favourites") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            
            guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
                print("Token not found")
                return
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error:", error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    print("No data returned")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode([Item].self, from: data)
                    
                    
                } catch {
                    print("Error decoding JSON:", error.localizedDescription)
                }
            }.resume() // Start the data task
        }
    }
