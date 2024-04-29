//
//  CreateOutfitView.swift
//  WardrobeApp
//
//  Created by Reeva Christie on 27/04/2024.
//

import SwiftUI

struct CreateOutfitView: View {
    @ObservedObject var viewModel = ItemsViewModel() //observedObject to track changes
    
    var body: some View {
        List(viewModel.items) { item in
            HStack {
                if let image = item.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50) //adjust as needed
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

#Preview {
    CreateOutfitView()
}
