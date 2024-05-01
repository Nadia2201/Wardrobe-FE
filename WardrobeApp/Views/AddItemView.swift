//
//  AddItemView.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 25/04/2024.
//

import SwiftUI
import Foundation

extension UIImage {
    func compressedImage() -> UIImage? {
        let maxSize: CGFloat = 500.0 // Set the maximum dimension
        let aspectRatio = self.size.width / self.size.height
        var newSize: CGSize
        
        if aspectRatio > 1 {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return newImage
    }
}
struct AddItemView: View {
    @State private var selectedCriteria: Set<String> = []
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var itemName = ""
    @State private var itemCategory = "Top"
    @State private var item: Item?
    @State private var isItemAdded = false
    @State private var clearFields = false
    let listOfCriteria = [
        ["title": "occasion", "listOfCriteria": ["casual", "smart", "sporty", "partywear"]],
        ["title": "weather", "listOfCriteria": ["summer", "winter", "rainy", "warm"]]
    ]
    
    
    
    var body: some View {
            VStack {
                Image("StyleSyncLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .accessibilityIdentifier("style-sync-logo")
                Text("Add a new clothing item to your wardrobe")
                    .padding()
                
                Button("Upload image") {
                    isImagePickerPresented = true
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
//                        .padding()
                }
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker("Category", selection: $itemCategory) {
                    ForEach(["Top", "Dress", "Bottom", "Shoes"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("Select tags that describe your item")
                    .multilineTextAlignment(.leading)
                //                    .padding()
                
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
                .padding()
                Button("Add to my wardrobe") {
                    //                             Create an Item object
                    // convert UIImage to base64
                    if let selectedImage = selectedImage {
                        // Compress the image
                        if let compressedImage = selectedImage.compressedImage() {
                            // Convert the compressed image to data
                            if let compressedImageData = compressedImage.jpegData(compressionQuality: 0.2) {
//                                 Convert compressed image data to base64
                                let imageConverted = compressedImageData.base64EncodedString()

                                Task {
                                    do {
                                        let itemService = ItemService()
                                        try await itemService.createItem(name: itemName, category: itemCategory.lowercased(), image: imageConverted, tags: Array(selectedCriteria))
                                        isItemAdded = true
                                        clearFields = true
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                
                            } else {
                                print("No image selected")
                            }
                            
                        }
                        
                    }
                    
                }
                .alert(isPresented: $isItemAdded) {
                    Alert(title: Text("Item added to your wardrobe"),
                          dismissButton: .default(Text("OK")))
                }
                //                NavigationLink(
                //                    destination: DashboardView(),
                //                    isActive: $isItemAdded)
//                {
//                    EmptyView()
//                }
//                .hidden()
                
                .onChange(of: clearFields) { value in
                    if value {
                        selectedImage = nil
                        itemName = ""
                        itemCategory = "Top"
                        selectedCriteria = []
                        clearFields = false
                    }
                }
            }
        }
    
        struct ImagePicker: View {
            @Binding var selectedImage: UIImage?
            @State private var isShowingImagePicker = false
            @Environment(\.presentationMode) private var presentationMode
            
            var body: some View {
                VStack {
                    Button("Select an image") {
                        isShowingImagePicker = true
                    }
                    .padding()
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePickerViewController(selectedImage: $selectedImage, presentationMode: _presentationMode)
                    }
                    
                    Spacer()
                }
            }
        }
        
        struct ImagePickerViewController: UIViewControllerRepresentable {
            @Binding var selectedImage: UIImage?
            @Environment(\.presentationMode) var presentationMode
            
            func makeUIViewController(context: Context) -> some UIViewController {
                let viewController = UIViewController()
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = context.coordinator
                imagePickerController.sourceType = .photoLibrary
                viewController.present(imagePickerController, animated: true, completion: nil)
                return viewController
            }
            
            func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
            
            func makeCoordinator() -> Coordinator {
                return Coordinator(parent: self)
            }
            
            class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                let parent: ImagePickerViewController
                
                init(parent: ImagePickerViewController) {
                    self.parent = parent
                }
                
                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    if let image = info[.originalImage] as? UIImage {
                        parent.selectedImage = image
                    }
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }

    struct AddItemView_Previews: PreviewProvider {
        static var previews: some View {
            AddItemView()
        }
    }

