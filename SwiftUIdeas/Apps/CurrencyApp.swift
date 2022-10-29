//
//  CurrencyApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 29/10/22.
//

import SwiftUI

struct CurrencyApp: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
            }
            .navigationTitle("Currency Converter")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left").fontWeight(.semibold)
                    }
                }
            }

        }
    }
}

struct CurrencyApp_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyApp()
    }
}
