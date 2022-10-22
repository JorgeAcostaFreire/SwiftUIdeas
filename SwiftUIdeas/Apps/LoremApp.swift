//
//  LoremApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 22/10/22.
//

import SwiftUI

struct LoremApp: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var loremText : String = ""
    @State var font : Font = .arial
    @State var fontSize : CGFloat = 20
    @State var isBold : Bool = false
    @State var isItalic : Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                TextEditor(text: $loremText)
                    .padding([.horizontal, .top])
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .font(.custom(self.font.rawValue, size: self.fontSize))
                    .italic(isItalic)
                    .bold(isBold)
            
                Form {
                    Section {
                        VStack {
                            HStack(spacing : 20) {
                                Picker(selection: self.$font) {
                                    ForEach(Font.allCases) { font in
                                        Text(font.rawValue).font(.custom(font.rawValue, size: 10))
                                    }
                                } label: {
                                    Text("Font")
                                }
                                Divider()
                                Toggle(isOn: $isBold) {
                                    Image(systemName: "bold")
                                }
                                .toggleStyle(.button)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                Divider()
                                Toggle(isOn: $isItalic) {
                                    Image(systemName: "italic")
                                }
                                .toggleStyle(.button)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                            Divider()
                            Stepper("Size", value: self.$fontSize, in: 10...30, step: 1.0)
                        }
                    }.frame(height: 70)
                    
                    Button {
                        if self.loremText.isEmpty {
                            self.loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 1.2, height: size / 5)
                            .overlay {
                                Text("Generate")
                                    .foregroundColor(.white)
                                    .font(.system(size: size / 7, weight: .bold, design: .rounded))
                            }
                    }
                }.frame(height: 250)
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

struct LoremApp_Previews: PreviewProvider {
    static var previews: some View {
        LoremApp()
    }
}

enum Font : String, Hashable, Identifiable, CaseIterable {
    case american = "American Typewriter"
    case arial = "Arial"
    case courier = "Courier"
    case avenir = "Avenir"
    case baskerville = "Baskerville"
    case damascus = "Damascus"
    case didot = "Didot"
    case georgia = "Georgia"
    case helvetica = "Helvetica"
    case marion = "Marion"
    case thonburi = "Thonburi"
    
    var id : Self {self}
}
