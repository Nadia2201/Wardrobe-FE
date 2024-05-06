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
//            Text("Welcome to your wardrobe \(username)!")
//                .padding()
            Text("Let's create a new outfit!")
            Picker("CreateOption", selection: $createOptions) {
                ForEach(["Customized", "Pick your items"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if createOptions == "Customized" {
                CreateRandomOutfitView()
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
