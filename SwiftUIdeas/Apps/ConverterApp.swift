//
//  ConverterApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 26/10/22.
//

import SwiftUI

struct ConverterApp: View {
    @Environment(\.dismiss) var dismiss
    @State var number : String = ""
    @State var numType : NumericType = .unknown
    @State var isNumberEntered : Bool = false
    @State var isNumberValid : Bool = false
    @State var conversions : [String] = []
    var isButtonDisabled : Bool {return number.isEmpty}
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                
                //Resultados de la conversion
                if self.numType != .unknown && self.isNumberValid  {
                    VStack {
                        VStack(spacing: 30){
                            HStack{
                                Text("2:")
                                Spacer()
                                Text(conversions[0])
                            }
                            HStack{
                                Text("8:")
                                Spacer()
                                Text(conversions[1])
                            }
                            HStack{
                                Text("10:")
                                Spacer()
                                Text(conversions[2])
                            }
                            HStack{
                                Text("16:")
                                Spacer()
                                Text(conversions[3])
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.top, 100)
                        .font(.custom("PressStart2P-Regular", size: 30))
                        .foregroundColor(.green)
                        Spacer()
                        Button {
                            self.number = ""
                            self.numType = .unknown
                            self.isNumberEntered = false
                            self.isNumberValid = false
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: size / 1.5, height: size / 4)
                                .foregroundColor(.green)
                                .overlay {
                                    Image(systemName: "arrow.clockwise")
                                        .foregroundColor(.black)
                                        .font(.system(size: size / 9, weight: .black, design: .rounded))
                                }
                        }
                    }
                }
            }
            
            if numType != .unknown && !isNumberValid {
                //Input del numero
                VStack{
                    TextField("", text: self.$number)
                        .padding()
                        .background (
                            Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                    
                    Button {
                        self.isNumberEntered = true
                        self.isNumberValid = numType.validate(self.number)
                        if self.isNumberValid {
                            self.conversions = self.numType.convert(self.number)
                        }
                    } label: {
                        Spacer()
                        Image(systemName: "checkmark")
                            .font(.system(.largeTitle, design: .rounded, weight: .black))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .disabled(self.isButtonDisabled)
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(self.isButtonDisabled ? Color.gray : Color.green)
                    .cornerRadius(10)
                    .frame(width: size / 3)
                    .overlay {
                        if self.isNumberEntered && !self.isNumberValid{
                            Button {
                                self.number = ""
                                self.isNumberEntered = false
                            } label: {
                                Spacer()
                                Image(systemName: "xmark")
                                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(10)
                            .scaleEffect(y:1.05)
                        }
                    }
                }.padding(.horizontal, 50)
            }
            
            if numType == .unknown {
                //Selecter de tipo
                VStack(spacing: 40){
                    Button {
                        self.numType = .binary
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 3, height: size / 5)
                            .foregroundColor(.green)
                            .overlay {
                                Text("2").font(.custom("PressStart2P-Regular", size: 50))
                                    .foregroundColor(.black)
                            }
                    }
                    
                    Button {
                        self.numType = .octal
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 3, height: size / 5)
                            .foregroundColor(.green)
                            .overlay {
                                Text("8").font(.custom("PressStart2P-Regular", size: 50))
                                    .foregroundColor(.black)
                            }
                    }
                    
                    Button {
                        self.numType = .decimal
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 3, height: size / 5)
                            .foregroundColor(.green)
                            .overlay {
                                Text("10").font(.custom("PressStart2P-Regular", size: 50))
                                    .foregroundColor(.black)
                            }
                    }
                    
                    Button {
                        self.numType = .hexadecimal
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: size / 3, height: size / 5)
                            .foregroundColor(.green)
                            .overlay {
                                Text("16").font(.custom("PressStart2P-Regular", size: 50))
                                    .foregroundColor(.black)
                            }
                    }

                }
            }
        }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct ConverterApp_Previews: PreviewProvider {
    static var previews: some View {
        ConverterApp()
    }
}

enum NumericType {
    case decimal
    case binary
    case hexadecimal
    case octal
    case unknown
    
    var base : Int {
        switch self{
        case .binary:
            return 2
        case .octal:
            return 8
        case .decimal:
            return 10
        case .hexadecimal:
            return 16
        case .unknown:
            return 1
        }
    }
    
    var alphabet : [Character : Int] {
        switch self{
        case .unknown:
            return [:]
        case .binary:
            return ["0" : 0, "1" : 1]
        case .octal:
            return [
                "0" : 0,
                "1" : 1,
                "2" : 2,
                "3" : 3,
                "4" : 4,
                "5" : 5,
                "6" : 6,
                "7" : 7
                ]
        case .decimal:
            return [
                "0" : 0,
                "1" : 1,
                "2" : 2,
                "3" : 3,
                "4" : 4,
                "5" : 5,
                "6" : 6,
                "7" : 7,
                "8" : 8,
                "9" : 9
                ]
        case .hexadecimal:
            return [
                "0" : 0,
                "1" : 1,
                "2" : 2,
                "3" : 3,
                "4" : 4,
                "5" : 5,
                "6" : 6,
                "7" : 7,
                "8" : 8,
                "9" : 9,
                "A" : 10,
                "B" : 11,
                "C" : 12,
                "D" : 13,
                "E" : 14,
                "F" : 15
                ]
        }
    }
    
    func validate(_ number : String) -> Bool {
        let numberArray = number.uppercased().split(separator: "")
        let alphabet = self.alphabet.keys
        
        for symbol in numberArray {
            if !alphabet.contains(symbol){return false}
        }
        return true
    }
    
    func convert(_ number : String) -> [String] {
        var numbers : [String] = []
        guard let decimalEquivalent = Int(number, radix: self.base) else {return numbers}
        numbers.append(String(decimalEquivalent, radix: 2, uppercase: true))
        numbers.append(String(decimalEquivalent, radix: 8, uppercase: true))
        numbers.append(String(decimalEquivalent, radix: 10, uppercase: true))
        numbers.append(String(decimalEquivalent, radix: 16, uppercase: true))
        return numbers
    }
    
}
