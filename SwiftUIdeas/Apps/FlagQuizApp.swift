//
//  FlagQuizApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 30/10/22.
//

import SwiftUI

struct FlagQuizApp: View {
    @Environment(\.dismiss) var dismiss
    @State var countries : [Country] = []
    @State var selectedCountry : Country?
    @State var firstCountry : Country?
    @State var secondCountry : Country?
    
    func selectNewCountry() {
        self.selectedCountry = self.countries[Int.random(in: 0..<self.countries.count)]
    }
    
    func selectCountries(){
        let firstRandom = Int.random(in: 0..<self.countries.count)
        let secondRandom = Int.random(in: 0..<self.countries.count)
        
        if firstRandom != secondRandom &&
            countries.firstIndex(of: selectedCountry!) != firstRandom &&
            countries.firstIndex(of: selectedCountry!) != secondRandom {
            self.firstCountry = countries[firstRandom]
            self.secondCountry = countries[secondRandom]
        } else {
            selectCountries()
        }
    }
    
    func fetchCountry() async {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {return}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode([Country].self, from: data)
            self.countries = item
            self.selectNewCountry()
            self.selectCountries()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                if let country = self.selectedCountry, let first = self.firstCountry, let sec = self.secondCountry {
                    VStack (spacing : 30) {
                        AsyncImage(url: URL(string: country.flags.png))
                        Text(country.name.common)
                        Text(first.name.common)
                        Text(sec.name.common)
                    }.padding(.vertical)
                } else {
                    ProgressView()
                }
                Spacer()
                Button {
                    selectNewCountry()
                    selectCountries()
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
            .padding()
            .task {
                await fetchCountry()
            }
            .navigationTitle("Flag Quiz")
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

struct FlagQuizApp_Previews: PreviewProvider {
    static var previews: some View {
        FlagQuizApp()
    }
}

struct Country : Hashable, Codable {
    let name : CountryName
    let cca2 : String
    let flags : CountryFlag
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name.official == rhs.name.official
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(cca2)
    }
}

struct CountryName : Codable {
    let common : String
    let official : String
}

struct CountryFlag : Codable {
    let png : String
}
