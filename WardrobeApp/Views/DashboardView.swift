//
//  DashboardView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 24/04/2024.
//

import SwiftUI

struct DashboardView: View {
    @State private var createOptions = ""
    @State private var showCriteria = false
    @State private var selectedCriteria: Set<String> = []
    let listOfCriteria = [
        ["title": "occasion", "listOfCriteria": ["casual", "smart", "sporty", "partywear"]],
        ["title": "weather", "listOfCriteria": ["summer", "winter", "rainy", "warm"]]
    ]
    let username = UserDefaults.standard.string(forKey: "accessUsername") ?? "Guest"
    var body: some View {
        
        
        VStack{
            Image("StyleSyncLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .accessibilityIdentifier("style-sync-logo")
            Text("Welcome to your wardrobe \(username)!")
                .padding()
            Text("Create a new outfit")
            Picker("CreateOption", selection: $createOptions) {
                ForEach(["Customized", "Random", "Pick your items"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if createOptions == "Customized" {
                List {
                    ForEach(0..<listOfCriteria.count) { index in
                        let criteria = listOfCriteria[index]
                        Section(header: Text(criteria["title"] as! String)) {
                            ForEach(criteria["listOfCriteria"] as! [String], id: \.self) { criterion in
                                Button(action: {
                                    if self.selectedCriteria.contains(criterion) {
                                        self.selectedCriteria.remove(criterion)
                                    } else {
                                        self.selectedCriteria.insert(criterion)
                                    }
                                }) {
                                    HStack {
                                        Text(criterion)
                                        
                                        if self.selectedCriteria.contains(criterion) {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "square")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else if createOptions == "Pick your items" {
                WardrobeView()
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
