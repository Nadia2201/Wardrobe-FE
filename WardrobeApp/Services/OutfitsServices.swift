//
//  OutfitsServices.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 30/04/2024.
//

import Foundation

class OutfitService : OutfitServiceProtocol {
    
    private var outfits: [Outfit] = []
    struct OutfitResponse: Decodable {
        let outfits: [Outfit]
        let token: String
    }
    
    
    static let shared = OutfitService()
    
    func fetchOutfitCreated(completion: @escaping (Outfit?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/outfits") else {
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
        print("OLD TOKEN BELOW")
        print(token)

        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching items: \(error?.localizedDescription ?? "Unknown error")")
            if let error = error {
                if(error as NSError).domain == NSURLErrorDomain, (error as NSError).code == NSURLErrorTimedOut {
                        print("Request timed out")
                    } else {
                        print("Network error", error.localizedDescription)
                             }
                             completion(nil)
                             return
                         }

                guard let data = data else {
                             print("No data returned")
            
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([Outfit].self, from: data)
                // Update token in UserDefaults with the new token received from backend
//                UserDefaults.standard.set(decodedResponse.token, forKey: "accessToken")
//                print("UPDATED TOKEN BELOW")
                let outfitsSortedByCreationTime = decodedResponse.sorted { $0.createdAt > $1.createdAt }
                if let lastOutfitCreated = outfitsSortedByCreationTime.first {
                DispatchQueue.main.async {
                    completion(lastOutfitCreated)
                }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
                print("decoded response:")
                print(decodedResponse)

            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    
    
    
    func createOutfitByTag(occasion: String, weather: String) async throws -> Void {
        let payload: [String: String] = ["occasion": occasion, "weather": weather]
        print(payload)
        let url = URL(string: "http://localhost:3000/outfits/createByTag")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
                print("Token not found")
                return
            }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
          throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
        }
        if httpResponse.statusCode == 201 {
            print("status code 201")
            return
        } else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: ["message": "Received status \(httpResponse.statusCode). Expected 201"])
        }
    }
    
    func createOutfitManually(top: String, bottom: String, shoes: String) async throws -> Void {
        let payload: [String: String] = ["top": top, "bottom": bottom, "shoes": shoes]
        print(payload)
        let url = URL(string: "http://localhost:3000/outfits/createManual")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
                print("Token not found")
                return
            }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
          throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
        }
        if httpResponse.statusCode == 201 {
            print("status code 201")
            return
        } else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: ["message": "Received status \(httpResponse.statusCode). Expected 201"])
        }
    }
}
