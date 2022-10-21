//
//  TitleView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct TitleView: View {
    @State var isEnterTapped : Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "figure.wave")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hi!")
                }
                .font(.system(size: size / 5, weight: .black, design: .rounded))
                .padding()
                Spacer(minLength: 50)
                Button {
                    self.isEnterTapped.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: size / 3)
                        .padding(.horizontal)
                        .overlay {
                            Text("Enter")
                                .foregroundColor(.white)
                                .font(.system(size: size / 8, weight: .bold, design: .rounded))
                        }
                        .padding(.bottom)
                }
            }
        }.fullScreenCover(isPresented: self.$isEnterTapped) {
            GalleryView()
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
