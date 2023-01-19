//
//  PickerApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 19/1/23.
//

import SwiftUI
import PhotosUI

struct PickerApp: View {
    
    @State private var selectedItem : PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    var body: some View {
        VStack{
            if let selectedPhotoData,
                let image = UIImage(data: selectedPhotoData) {
             
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
             
            }
            
            PhotosPicker(selection: self.$selectedItem, label: {
                Label("Select a photo", systemImage: "photo")
            })
            .tint(.purple)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedPhotoData = data
                    }
                }
            }
        }
    }
}

struct PickerApp_Previews: PreviewProvider {
    static var previews: some View {
        PickerApp()
    }
}
