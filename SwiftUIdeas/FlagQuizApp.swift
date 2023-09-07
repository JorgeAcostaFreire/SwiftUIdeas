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
    @State var options : [Country] = []
    @State var selectedCountry : Country?
    @State var firstCountry : Country?
    @State var secondCountry : Country?
    @State var resultColor : Color = Color(.systemGray5)
    @State var isTapped1 : Bool = false
    @State var isTapped2 : Bool = false
    @State var isTapped3 : Bool = false
    
    
    func checkCountry(country : Country) async {
        if country == self.selectedCountry{
            self.resultColor = .green
        } else {
            self.resultColor = .red
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.isTapped1 = false
        self.isTapped2 = false
        self.isTapped3 = false
        self.resultColor = Color(.systemGray5)
        selectNewCountry()
        selectCountries()
        self.options.removeSubrange(0...2)
        self.options.shuffle()
    }
    
    func selectNewCountry() {
        self.selectedCountry = self.countries[Int.random(in: 0..<self.countries.count)]
        self.options.append(self.selectedCountry!)
    }
    
    func selectCountries(){
        let firstRandom = Int.random(in: 0..<self.countries.count)
        let secondRandom = Int.random(in: 0..<self.countries.count)
        
        if firstRandom != secondRandom &&
            countries.firstIndex(of: selectedCountry!) != firstRandom &&
            countries.firstIndex(of: selectedCountry!) != secondRandom {
            self.firstCountry = countries[firstRandom]
            self.secondCountry = countries[secondRandom]
            self.options.append(self.firstCountry!)
            self.options.append(self.secondCountry!)
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
            self.options.shuffle()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if self.options.count == 3 {
                    if let country = self.selectedCountry{
                        VStack (spacing : 10) {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.systemGray6))
                                .overlay{
                                AsyncImage(url: URL(string: country.flags.png))
                                }
                            Spacer()
                            Button {
                                self.isTapped1 = true
                                Task{
                                    await checkCountry(country: options[0])
                                }
                            } label: {
                                ButtonView(countryName: self.options[0].name.common, color: self.resultColor, isTapped: self.$isTapped1)
                            }
                            Button {
                                self.isTapped2 = true
                                Task{
                                    await checkCountry(country: options[1])
                                }
                            } label: {
                                ButtonView(countryName: self.options[1].name.common, color: self.resultColor, isTapped: self.$isTapped2)
                            }
                            Button {
                                self.isTapped3 = true
                                Task{
                                    await checkCountry(country: options[2])
                                }
                            } label: {
                                ButtonView(countryName: self.options[2].name.common, color: self.resultColor, isTapped: self.$isTapped3)
                            }
                        }
                    }
                } else {
                    ProgressView()
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



struct ButtonView : View {
    @Environment(\.colorScheme) var colorScheme
    var countryName : String
    var color : Color
    @Binding var isTapped : Bool
    
    var body: some View{
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.clear)
            .padding()
            .frame(height: 100)
            .background(content: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 7)
                    .foregroundColor(isTapped ? color : Color(.systemGray5))
            })
            .overlay{
                Text(countryName)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .padding(.horizontal, 5)
            }
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
