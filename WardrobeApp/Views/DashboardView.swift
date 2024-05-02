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
    @State private var occasion = ""
    @State private var weather = ""
    @State private var clearFields = false
    @State private var outfitCreated: [String] = []
    @State private var top = "1"
    @State private var bottom = "2"
    @State private var shoes = "3"
    @State private var showingAlert = false
    @State private var alertMessage = ""
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
                .frame(width: 100, height: 100)
                .accessibilityIdentifier("style-sync-logo")
            Text("Welcome to your wardrobe \(username)!")
                .padding()
            Text("Create a new outfit")
            Picker("CreateOption", selection: $createOptions) {
                ForEach(["Customized", "Pick your items"], id: \.self) {
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
                Button(action:  {
                    occasion = Array(selectedCriteria)[0]
                    weather = Array(selectedCriteria)[1]
                    Task {
                        do {
                            let outfitService = OutfitService()
                            try await outfitService.createOutfitByTag(occasion: occasion, weather: weather)
                            clearFields = true
                            showingAlert = true
                            alertMessage = "Added to your Outfits"
//                            outfitCreated = try await outfitService.fetchOutfitCreated()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    Text("Create outfit")
                }
                .onChange(of: clearFields) { value in
                    if value {
                        selectedCriteria = []
                        clearFields = false
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Outfit Added"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            } else if createOptions == "Pick your items" {
//                let outfitService = OutfitService()
//                try await outfitService.createOutfitManually(top: top, bottom: bottom, shoes: shoes)
                CreateOutfitManually()
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
