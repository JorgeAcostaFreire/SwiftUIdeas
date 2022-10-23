//
//  ChristmasApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 23/10/22.
//

import SwiftUI

struct ChristmasApp: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var lightsOn : Bool = false
    @State var timer : Timer?
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.lightsOn.toggle()
        })
    }
    
    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? .green : .black)
                        .frame(width:size + 20, height: 10).offset(y:40)
                    HStack (spacing : 20){
                        ChristmasLight(lightsOn: self.$lightsOn, color: .red)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .blue)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .green)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .orange)
                    }
                }.rotationEffect(Angle(degrees: 5))
                VStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? .green : .black)
                        .frame(width:size + 20, height: 10).offset(y:40)
                    HStack (spacing : 20){
                        ChristmasLight(lightsOn: self.$lightsOn, color: .pink)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .purple)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .mint)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .yellow)
                    }
                }.rotationEffect(Angle(degrees: -5))
                VStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? .green : .black)
                        .frame(width:size + 20, height: 10).offset(y:40)
                    HStack (spacing : 20){
                        ChristmasLight(lightsOn: self.$lightsOn, color: .yellow)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .green)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .teal)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .red)
                    }
                }.rotationEffect(Angle(degrees: 5))
                VStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? .green : .black)
                        .frame(width:size + 20 ,height: 10).offset(y:40)
                    HStack (spacing : 20){
                        ChristmasLight(lightsOn: self.$lightsOn, color: .blue)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .orange)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .purple)
                        ChristmasLight(lightsOn: self.$lightsOn, color: .pink)
                    }
                }.rotationEffect(Angle(degrees: -5))
                Spacer()
                Button {
                    withAnimation (.easeInOut){
                        lightsOn.toggle()
                    }
                } label: {
                    Image(systemName: "bolt.square.fill")
                        .font(.system(size: size / 5, weight: .black))
                        .foregroundColor(lightsOn ? .accentColor : .gray)
                }.padding(.top)
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

struct ChristmasApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChristmasApp()
            ChristmasLight(lightsOn: .constant(true), color: .red)
        }
    }
}

struct ChristmasLight : View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var lightsOn : Bool
    var color : Color
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5).frame(width: 10, height: 30).foregroundColor(colorScheme == .dark ? .green : .black).offset(y:30)
            RoundedRectangle(cornerRadius: 5).frame(width: 40, height: 20).foregroundColor(colorScheme == .dark ? .green : .black).offset(y:20)
            Circle().foregroundColor(color).frame(width: 80, height: 80).saturation(lightsOn ? 1.0 : 0.3).brightness(0.1)
        }
    }
}
