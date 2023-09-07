//
//  TitleView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "figure.wave")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 100, weight: .black, design: .rounded))
                Spacer()
                NavigationLink {
                    GalleryView()
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 120)
                        .padding(.horizontal)
                        .overlay {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .scaleEffect(1.8)
                        }
                        .padding(.bottom, 5)
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
