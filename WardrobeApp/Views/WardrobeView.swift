//
//  WardrobeView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 29/04/2024.
//

import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes

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
