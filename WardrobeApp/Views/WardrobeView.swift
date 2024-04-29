//
//  WardrobeView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 29/04/2024.
//

import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes
//    @State var isFavorite: Bool
         var body: some View {
             List(viewModel.items) { item in
                 HStack {
                     if let image = item.uiImage {
                         Image(uiImage: image)
                             .resizable()
                             .scaledToFit()
                             .frame(width: 50, height: 50) 
                     }
                     VStack(alignment: .leading) {
                         Text("Name: \(item.name)")
                         Text("Category: \(item.category)")
                         Text("Tags: \(item.tags.joined(separator: ", "))")
                     }
//                     Button(action: {
//                        isFavorite.toggle() // Toggle the favorite status
//                        favouriteItem(isFavorite: isFavorite) // Handle button click
//                                 }) {
//                                     Image(systemName: isFavorite ? "heart.fill" : "heart") // Change icon based on status
//                                         .foregroundColor(isFavorite ? .red : .gray)
//                                 }
//                             }
                     Image(systemName: "heart")
                 }
             }
            
             .onAppear{
                 viewModel.fetchItems() //fetch items when the view appears
             }
         }
     }


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}
