//
//  BackButtonView.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 18/1/23.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack{
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title)
            }.padding(.leading)
            Spacer()
        }.padding(.top)
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView()
    }
}
