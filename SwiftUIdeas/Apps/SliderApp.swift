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
    @State var color : Color = .mint
    @State var squareSize : CGFloat = size
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(self.color)
                    .padding()
                    .frame(width: squareSize, height: squareSize)
                Spacer()
                Form{
                    HStack(spacing : 40) {
                        Label("Radius", systemImage: "circle.and.line.horizontal.fill")
                        Slider(value: self.$radius, in: 0...squareSize/2)
                    }
                    ColorPicker(selection: self.$color) {
                        Label("Color", systemImage: "paintbrush.fill")
                    }
                    Stepper(value: $squareSize, in: 100...size, step: 20) {
                        Label("Size", systemImage: "ruler.fill")
                    }
                }.frame(height: 200).cornerRadius(10)
            }
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
