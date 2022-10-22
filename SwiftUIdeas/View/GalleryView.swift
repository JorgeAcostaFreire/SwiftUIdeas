//
//  GalleryView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    NavigationLink {
                        SliderApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "SliderApp")
                    }
                    Spacer()
                    NavigationLink {
                        GaugeApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "GaugeApp")
                    }
                }.padding()
                HStack {
                    NavigationLink {
                        PictureApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "PictureApp")
                    }
                    Spacer()
                    Button {
                        //
                    } label: {
                        AppView(name: "None")
                    }
                }.padding()
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
            }
            .navigationTitle("Gallery").navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}

struct AppView: View {
    var name : String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: size / 2.5, height: size / 2.5)
            .foregroundColor(.clear)
            .overlay {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .clipped()
            }
    }
}
