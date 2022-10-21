//
//  SliderApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct SliderApp: View {
    @Environment (\.dismiss) var dismiss
    @State var radius : CGFloat = 10.0
    @State var color : Color = .black
    var body: some View {
        NavigationView {
            VStack{
                RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(self.color)
                    .padding()
                    .frame(width: size, height: size)
                Slider(value: self.$radius, in: 0...size/2).padding(.vertical)
                ColorPicker(selection: self.$color) {
                    Label("Color", systemImage: "paintbrush.fill").foregroundColor(.accentColor)
                }
            }.padding(.horizontal)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }

                }
            }
        }
    }
}

struct SliderApp_Previews: PreviewProvider {
    static var previews: some View {
        SliderApp()
    }
}
