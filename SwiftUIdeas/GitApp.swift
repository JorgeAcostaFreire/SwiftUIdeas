//
//  GitApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 28/10/22.
//

import SwiftUI

struct GitApp: View {
    @Environment(\.dismiss) var dismiss
    @State var results : GitResult?
    
    func fetchResults() async {
        guard let url = URL(string: "https://www.githubstatus.com/api/v2/components.json") else {
            print("Invalid URL")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(GitResult.self, from: data)
            results = item
            let _ = results?.components.remove(at: 3)
            //results?.components.append(pageUrl!)
        } catch {
            print("Invalid data")
        }
        
    }
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                if let results = self.results?.components {
                    ForEach(results, id: \.id) { result in
                        HStack {
                            Text(result.name).font(.system(.title2, design: .rounded, weight: .semibold))
                            Spacer()
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(result.status == "operational" ? .green : .red)
                        }
                        .padding()
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.systemGray5))
                                .padding(.horizontal, 10)
                        }
                    }
                }
                 
            }.task {
                await fetchResults()
            }
            .navigationTitle("GitHub Status")
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

struct GitApp_Previews: PreviewProvider {
    static var previews: some View {
        GitApp()
    }
}

struct GitPage : Codable {
    let id, name, url, time_zone, updated_at : String
}

struct GitComponent : Codable {
    let id : String
    let name : String
    let status : String
}

struct GitResult : Codable {
    let page : GitPage
    var components : [GitComponent]
}

struct GitStatus : Codable {
    let description, indicator : String
}
