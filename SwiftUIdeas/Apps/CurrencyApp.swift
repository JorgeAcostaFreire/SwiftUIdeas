//
//  CurrencyApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 29/10/22.
//

import SwiftUI

struct CurrencyApp: View {
    @Environment(\.dismiss) var dismiss
    @State var symbol : Symbol?
    @State var exchange : Exchange?
    @State var baseKey : String = ""
    @State var finalKey : String = ""
    @State var quantity : Int = 0
    
    private let api_key : String = "fMpPFVNIytmCsAwpFyvMiahiRPNL7JU5"
    
    func fetchSymbols() async {
        guard let url = URL(string: "https://api.apilayer.com/exchangerates_data/symbols?apikey=\(api_key)") else {return}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(Symbol.self, from: data)
            self.symbol = item
        } catch {
            print(error)
        }
    }
    
    func fetchResult() async {
        guard let url = URL(string: "https://api.apilayer.com/exchangerates_data/convert?to=\(finalKey)&from=\(baseKey)&amount=\(quantity)&apikey=\(api_key)") else {return}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(Exchange.self, from: data)
            self.exchange = item
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing : 80){
                if let symbolsDicc = self.symbol?.symbols{
                    VStack(spacing : 20){
                        Picker("", selection: self.$baseKey) {
                            ForEach(symbolsDicc.keys.sorted(), id: \.self) { key in
                                Text(symbolsDicc[key]!)
                            }
                        }
                        Image(systemName: "arrow.down").fontWeight(.bold).font(.system(.title))
                        Picker("", selection: self.$finalKey) {
                            ForEach(symbolsDicc.keys.sorted(), id: \.self) { key in
                                Text(symbolsDicc[key]!)
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
                    Task{
                        await fetchResult()
                    }
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
                if let exchange = self.exchange{
                    ExchangeView(exchange: exchange, baseCurrency: baseKey, destinationCurrency: finalKey, baseAmount: quantity)
                }
            }
            .task {
                await fetchSymbols()
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

struct Exchange : Codable {
    let success : Bool
    let query : ExchangeQuery
    let info : ExchangeInfo
    let date : String
    let result : Double
    
}

struct ExchangeQuery : Codable {
    let from : String
    let to : String
    let amount : Int
}

struct ExchangeInfo : Codable {
    let timestamp : Int
    let rate : Double
}

struct ExchangeView : View {
    var exchange  : Exchange
    var baseCurrency : String
    var destinationCurrency : String
    var baseAmount : Int
    
    var body: some View {
        VStack{
            HStack(spacing : 20){
                VStack(spacing : 10){
                    Text("\(baseAmount)")
                    Text(baseCurrency)
                }
                Spacer()
                Image(systemName: "arrowshape.right.fill").foregroundColor(.accentColor)
                Spacer()
                VStack(spacing : 10){
                    Text("\(exchange.result)")
                    Text(destinationCurrency)
                }
            }
            .font(.system(.title, design: .rounded, weight: .semibold))
            .padding(.horizontal, 40)
        }
    }
}


