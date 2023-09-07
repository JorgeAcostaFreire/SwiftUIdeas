//
//  GaugeApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct GaugeApp: View {
    @Environment (\.dismiss) var dismiss
    @State var timer : Timer?
    @State var gameTimer : Timer?
    @State var gameTime : Int = 0
    @State var taps : Int = 0
    @State var currentVal : Double = 0.0
    @State var isStarted : Bool = false
    @State var isEnded : Bool = false
    let maxVal : Double = 100.0
    let minVal : Double = 0.0
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.currentVal -= 0.1
            if currentVal < minVal {currentVal = minVal}
            if currentVal >= maxVal {
                self.isStarted = false
                self.isEnded.toggle()
                self.gameTimer!.invalidate()
                self.currentVal = minVal + 0.1
                self.timer!.invalidate()
            }
        })
    }
    
    func startGameTimer(){
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.gameTime += 1
        })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Gauge(value: currentVal, in: minVal...maxVal) {
                    Image(systemName: "crown.fill").padding(.bottom, 30).foregroundColor(.accentColor)
                } currentValueLabel: {
                    Text("")
                } minimumValueLabel: {
                    Text("")
                } maximumValueLabel: {
                    Text("")
                }
                .font(.system(size: size / 10))
                .fontWeight(.bold)
                .padding(.bottom, 200)
                .padding(.horizontal)
                
                if self.isStarted{
                    Button {
                        self.taps += 1
                        self.currentVal += 5.0
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 1.5, height: size / 4)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: size / 7, weight: .black))
                            }
                    }
                } else {
                    Button {
                        self.isStarted = true
                        self.taps = 0
                        self.gameTime = 0
                        self.startGameTimer()
                        self.startTimer()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 1.5, height: size / 4)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: size / 7))
                            }
                    }
                }
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }

                }
            }
        }.sheet(isPresented: self.$isEnded) {
            EndgameView(gameTime: self.$gameTime, taps: self.$taps)
        }

    }
}

struct GaugeApp_Previews: PreviewProvider {
    static var previews: some View {
        GaugeApp()
    }
}

struct EndgameView : View {
    @Environment (\.dismiss) var dismiss
    @Binding var gameTime : Int
    @Binding var taps : Int
    var gameMinutes : Int {return (gameTime % 3600) / 60}
    var gameSeconds : Int {return gameTime % 60}
    
    var body: some View{
        VStack{
            VStack (spacing : 50) {
                HStack {
                    Image(systemName: "timer")
                    Text(gameSeconds < 10 ? "\(gameMinutes):0\(gameSeconds)" : "\(gameMinutes):\(gameSeconds)")
                }
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("\(taps)")
                }
            }
            .foregroundColor(.accentColor)
            .font(.system(size: size / 7, weight: .black, design: .rounded))
            .padding(.bottom, 200)
            .padding(.horizontal)
            
            Button {
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: size / 1.5, height: size / 4)
                    .overlay {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                            .font(.system(size: size / 9, weight: .black, design: .rounded))
                    }
            }
        }
    }
}
