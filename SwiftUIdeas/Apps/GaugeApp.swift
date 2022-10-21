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
    @State var currentVal : Double = 0.0
    @State var isStarted : Bool = false
    let maxVal : Double = 100.0
    let minVal : Double = 0.0
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            self.currentVal -= 5.0
            if currentVal < minVal {currentVal = minVal}
            if currentVal >= maxVal {
                self.isStarted = false
                self.currentVal = minVal
                self.timer!.invalidate()
            }
        })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Gauge(value: currentVal, in: minVal...maxVal) {
                    Image(systemName: "crown.fill").padding(.bottom)
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
                if currentVal >= maxVal {
                    Text("You won!")
                        .font(.system(size: size / 10, weight: .black, design: .rounded))
                        .padding(.bottom, 100)
                }
                if self.isStarted{
                    Button {
                        self.currentVal += 5.0
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 1.5, height: size / 4)
                            .overlay {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: size / 7, weight: .black))
                                    .rotationEffect(Angle(degrees: 45.0))
                            }
                    }
                } else {
                    Button {
                        self.isStarted = true
                        self.startTimer()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 1.5, height: size / 4)
                            .overlay {
                                Text("Start")
                                    .foregroundColor(.white)
                                    .font(.system(size: size / 7, weight: .black, design: .rounded))
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
        }

    }
}

struct GaugeApp_Previews: PreviewProvider {
    static var previews: some View {
        GaugeApp()
    }
}
