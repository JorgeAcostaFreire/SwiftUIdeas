//
//  CurrencyApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 29/10/22.
//

import SwiftUI

struct CurrencyApp: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var symbol : Symbol?
    @State var baseKey : String = ""
    @State var finalKey : String = ""
    @State var quantity : Int = 0
    
    private let api_key : String = "fMpPFVNIytmCsAwpFyvMiahiRPNL7JU5"
    
    func fetchSymbols() async {
        guard let url = URL(string: "https://api.apilayer.com/exchangerates_data/symbols?apikey=\(api_key)") else {return}
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            print(response)
            let item = try JSONDecoder().decode(Symbol.self, from: data)
            self.symbol = item
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                if let symbolsDicc = self.symbol?.symbols{
                    HStack{
                        Picker("", selection: self.$baseKey) {
                            ForEach(symbolsDicc.keys.sorted(), id: \.self) { key in
                                Text(symbolsDicc[key]!).foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                        Image(systemName: "arrowshape.right.fill").fontWeight(.bold).foregroundColor(.accentColor)
                        Picker("", selection: self.$finalKey) {
                            ForEach(symbolsDicc.keys.sorted(), id: \.self) { key in
                                Text(symbolsDicc[key]!).foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                }
                HStack(spacing : 50){
                    Button {
                        self.quantity -= 1
                    } label: {
                        Image(systemName: "minus.square.fill")
                    }.disabled(self.quantity < 1)
                    Text("\(self.quantity)")
                    Button {
                        self.quantity += 1
                    } label: {
                        Image(systemName: "plus.square.fill")
                    }
                }.font(.system(.largeTitle, design: .rounded, weight: .bold))
                Button {
                    //
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .padding()
                        .frame(height: 100)
                        .overlay{
                            Image(systemName: "arrow.2.squarepath")
                                .foregroundColor(.white)
                                .font(.system(.title, design: .rounded, weight: .bold))
                        }
                }

            }
            .task {
                //await fetchSymbols()
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

struct Symbol : Codable {
    let success : Bool
    let symbols : [String : String]
}
