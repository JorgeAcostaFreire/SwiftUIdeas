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
                Image(systemName: "figure.wave")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .font(.system(size: size / 5, weight: .black, design: .rounded))
                    .padding()
                Spacer(minLength: 50)
                NavigationLink {
                    GalleryView().navigationBarBackButtonHidden()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: size / 3)
                        .padding(.horizontal)
                        .overlay {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.white)
                                .font(.system(size: size / 6, weight: .bold, design: .rounded))
                        }
                        .padding(.bottom)
                }
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
