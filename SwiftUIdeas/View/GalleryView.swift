//
//  GalleryView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    @State var sliderTapped : Bool = false
    @State var gaugeTapped : Bool = false
    @State var pictureTapped : Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Button {
                        self.sliderTapped.toggle()
                    } label: {
                        AppView(name: "SliderApp")
                    }
                    Spacer()
                    Button {
                        self.gaugeTapped.toggle()
                    } label: {
                        AppView(name: "GaugeApp")
                    }
                }.padding()
                HStack {
                    Button {
                        self.pictureTapped.toggle()
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
            .fullScreenCover(isPresented: self.$sliderTapped) {
                SliderApp()
            }
            .fullScreenCover(isPresented: self.$gaugeTapped) {
                GaugeApp()
            }
            .fullScreenCover(isPresented: self.$pictureTapped) {
                PictureApp()
            }
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
