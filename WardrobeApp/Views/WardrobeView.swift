//
//  WardrobeView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 29/04/2024.
//

import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = ItemsViewModel() // ObservedObject to track changes
    @ObservedObject var outfitViewModel = OutfitsViewModel()
    var body: some View {
        List {
            Section(header: Text("My clothing items")) {
                Section(header: Text("Tops")) {
                    ForEach(viewModel.items.filter({ $0.category == "top" || $0.category == "dress" })) { item in
                        ItemRow(item: item)
                    }
                }
                Section(header: Text("Bottoms")) {
                    ForEach(viewModel.items.filter({ $0.category == "bottom" })) { item in
                        ItemRow(item: item)
                    }
                }
                Section(header: Text("Shoes")) {
                    ForEach(viewModel.items.filter({ $0.category == "shoes" })) { item in
                        ItemRow(item: item)
                    }
                }
            }
            Section(header: Text("My outfits")) {
                ForEach(outfitViewModel.outfits) { outfit in
                    VStack(alignment: .leading) {
                        Text("Top: \(outfit.top)")
                        if let bottom = outfit.bottom {
                            Text("Bottom: \(bottom)")
                        }
                        Text("Shoes: \(outfit.shoes)")
                        Text("Created At: \(outfit.createdAt)")
                        Image(systemName: outfit.favourite ? "heart.fill" : "heart")
                            .foregroundColor(outfit.favourite ? .red : .gray)
                    }
                    .padding()
                }
            }
        }
        .listStyle(InsetGroupedListStyle()) // Apply inset grouped list style
        .onAppear {
            viewModel.fetchItems() // Fetch items when the view appears
            outfitViewModel.fetchOutfitCreated()
        }
    }
}

struct ItemRow: View {
    let item: Item
    
    var body: some View {
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
            Image(systemName: "heart")
        }
    }
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}
