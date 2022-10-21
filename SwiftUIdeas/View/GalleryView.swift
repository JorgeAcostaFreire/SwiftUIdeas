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
                    AppView(name: "None")
                }.padding(.horizontal)
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
            .fullScreenCover(isPresented: self.$sliderTapped) {
                SliderApp()
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
