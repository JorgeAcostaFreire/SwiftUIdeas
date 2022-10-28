//
//  GalleryView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    NavigationLink {
                        SliderApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "SliderApp")
                    }
                    Spacer()
                    NavigationLink {
                        GaugeApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "GaugeApp")
                    }
                }.padding()
                HStack {
                    NavigationLink {
                        PictureApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "PictureApp")
                    }
                    Spacer()
                    NavigationLink {
                        LoremApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: colorScheme == .dark ? "LoremAppDark" : "LoremApp")
                    }
                }.padding()
                HStack {
                    NavigationLink {
                        FruitApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: colorScheme == .dark ? "StackNavDark" : "StackNav")
                    }
                    Spacer()
                    NavigationLink {
                        CoreTaskApp()
                            .navigationBarBackButtonHidden()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    } label: {
                        AppView(name: "TaskApp")
                    }
                }.padding()
                HStack {
                    NavigationLink {
                        ChristmasApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: colorScheme == .dark ? "ChristmasApp" : "ChristmasAppDark")
                    }
                    Spacer()
                    NavigationLink {
                        ConverterApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: colorScheme == .dark ? "ConverterAppDark" : "ConverterApp")
                    }
                }.padding()
                HStack {
                    NavigationLink {
                        WikiApp().navigationBarBackButtonHidden()
                    } label: {
                        AppView(name: "WikiApp")
                    }
                    Spacer()
                    NavigationLink {
                        //
                    } label: {
                        AppView(name: "None")
                    }
                }.padding()
            }
            .padding()
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

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}

struct AppView: View {
    var name : String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: size / 2.5, height: size / 2.5)
            .foregroundColor(.clear)
            .overlay {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size / 2.5, height: size / 2.5)
                    .cornerRadius(10)
                    .clipped()
            }
    }
}
