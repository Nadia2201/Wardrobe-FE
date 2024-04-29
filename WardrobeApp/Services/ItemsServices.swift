//
//  ItemsServices.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 25/04/2024.
//

import Foundation

class ItemService : ItemServiceProtocol {
    
    
    private var items: [Item] = []
    struct ItemResponse: Decodable {
        let items: [Item]
        let token: String
    }
    

    static let shared = ItemService()
    func fetchItems(completion: @escaping ([Item]) -> Void) {
        guard let url = URL(string: "http://localhost:3000/items") else {
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

        print("Hello from ItemsServices 1")
        print("Request URL:", request.url?.absoluteString ?? "N/A")
        print("HTTP Method:", request.httpMethod ?? "N/A")
        print("Headers:", request.allHTTPHeaderFields ?? [:])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
    
            if let error = error {
                if(error as NSError).domain == NSURLErrorDomain, (error as NSError).code == NSURLErrorTimedOut {
                    print("Request timed out")
                } else {
                    print("Network error", error.localizedDescription)
                }
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }

            print("Hello from ItemsServices 2")
            do {
                print("Hello from ItemsServices 3")
//                let decodedResponse = try JSONDecoder().decode(ItemResponse.self, from: data)
                let decodedResponse = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
                
                print(decodedResponse)
                // Update token in UserDefaults with the new token received from backend
//                UserDefaults.standard.set(decodedResponse.token, forKey: "accessToken")
//                print("UPDATED TOKEN BELOW")
//                print(decodedResponse.token)
//                DispatchQueue.main.async {
//                    completion(decodedResponse.items)
//                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func createItem(name: String, category: String, image: String, tags: [String]) async throws -> Void {

        let payload: [String: Any] = [
            "name": name,
            "category": category,
            "image": image,
            "tags": tags
        ]
        print(payload)
        let url = URL(string: "http://localhost:3000/items")!

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
          throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: ["message": "Received status \(httpResponse.statusCode) when signing up. Expected 201"])
        }
      }
}
