//
//  FruitApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 22/10/22.
//

import SwiftUI

struct FruitApp: View {
    @Environment (\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Fruit.allCases) { fruit in
                        NavigationLink(fruit.name, value: fruit)
                    }
                } header: {Text("Fruits").bold()}
            }
            .frame(height: size)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Fruit.self) { fruit in
                FruitView(fruit: fruit).navigationBarBackButtonHidden()
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
            }
            Spacer()
            Image(systemName: "leaf.fill")
                .font(.system(size: size / 2, weight: .black))
                .foregroundColor(.green)
            Spacer()
        }
    }
}

struct FruitApp_Previews: PreviewProvider {
    static var previews: some View {
        FruitApp()
    }
}

struct FruitView: View {
    @Environment (\.dismiss) var dismiss
    var fruit : Fruit
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Spacer()
                VStack {
                    Text(self.fruit.rawValue)
                        .font(.system(size: size / 4))
                        .padding(.bottom)
                    Text(self.fruit.name)
                }
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.semibold)
                Spacer()
            }
            Spacer()
        }.background {
            self.fruit.color.edgesIgnoringSafeArea(.all)
        }.toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left").foregroundColor(.black)
                }
            }
        }
    }
}

enum Fruit : String, Hashable, CaseIterable, Identifiable {
    case apple = "🍏"
    case orange = "🍊"
    case banana = "🍌"
    
    var id : String {self.rawValue}
    
    var name : String {
        switch self {
        case .orange:
            return "Orange"
        case .apple:
            return "Apple"
        case .banana:
            return "Banana"
        }
    }
    
    var color : Color {
        switch self {
        case .apple:
            return .green
        case .orange:
            return .orange
        case .banana:
            return .yellow
        }
    }
}
