//
//  ChristmasApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 23/10/22.
//

import SwiftUI

struct ChristmasApp: View {
    @Environment(\.dismiss) var dismiss
    @State var allOn : Bool = false
    @State var switches : [Bool] = [false, false, false, false]
    @State var timer : Timer?
    
    
    
    var body: some View {
            VStack{
                BackButtonView()
                ChristmasString(switches: self.$switches, order: [0, 1, 2, 3],
                                colors: [.red, .blue, .green, .orange], slope: 5)
                ChristmasString(switches: self.$switches, order: [3, 1, 2, 0],
                                colors: [.pink, .purple, .mint, .yellow], slope: -5)
                ChristmasString(switches: self.$switches, order: [1, 2, 0, 3],
                                colors: [.yellow, .green, .teal, .red], slope: 5)
                ChristmasString(switches: self.$switches, order: [2, 0, 3, 1],
                                colors: [.blue, .orange, .purple, .pink], slope: -5)
                Spacer()
                LightButton(switches: self.$switches, allOn: self.$allOn, timer: self.$timer)
            }
    }
}

struct ChristmasApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChristmasApp()
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
            Circle().foregroundColor(color).frame(width: 80, height: 80).saturation(lightsOn ? 1.0 : 0.2).brightness(0.1)
        }
    }
}

struct ChristmasString : View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var switches : [Bool]
    var order : [Int]
    var colors : [Color]
    var slope : Double
    var body: some View{
        VStack {
            Rectangle()
                .foregroundColor(colorScheme == .dark ? .green : .black)
                .frame(width: size + 20, height: 10).offset(y:40)
            HStack (spacing : 20){
                ChristmasLight(lightsOn: self.$switches[order[0]], color: self.colors[0])
                ChristmasLight(lightsOn: self.$switches[order[1]], color: self.colors[1])
                ChristmasLight(lightsOn: self.$switches[order[2]], color: self.colors[2])
                ChristmasLight(lightsOn: self.$switches[order[3]], color: self.colors[3])
            }
        }.rotationEffect(Angle(degrees: self.slope))
    }
}

struct LightButton : View {
    @Binding var switches : [Bool]
    @Binding var allOn : Bool
    @Binding var timer : Timer?
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true, block: { _ in
            let random = Int.random(in: 0..<self.switches.count)
            self.switches[random].toggle()
        })
        self.allOn = true
    }
    
    func stopTimers() {
        self.timer?.invalidate()
        self.switches = [false, false, false, false]
        self.allOn = false
    }
    
    var body: some View{
        Button {
            withAnimation (.easeInOut){
                if self.allOn{
                    self.stopTimers()
                } else {
                    self.startTimer()
                }
            }
        } label: {
            Image(systemName: "bolt.square.fill")
                .font(.system(size: size / 5, weight: .black))
                .foregroundColor(allOn ? .accentColor : .gray)
        }.padding(.top)
    }
}
