//
//  GalleryView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.colorScheme) var colorScheme
    let viewContext = PersistenceController.shared.container.viewContext
    let gridItems: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: gridItems) {
                ForEach(DemoApp.allCases) { app in
                    NavigationLink {
                        app.view(context: viewContext)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Image(app.name(colorScheme == .dark))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }.padding(.bottom)
                }
            }
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
