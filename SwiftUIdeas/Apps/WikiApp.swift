//
//  WikiApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 28/10/22.
//

import SwiftUI

struct WikiApp: View {
    @Environment(\.dismiss) var dismiss
    @State private var pages = [Page]()
    @State var search : String = ""
    @State var searchedTerm : String?
    var lang : String {
        if Locale.current.identifier.contains("es") {
            return "es"
        } else {
            return "en"
        }
    }
    
    func convertSearch(_ search : String) -> String? {
        var finalSearch : String = ""
        if search.contains(" ") {
            let searchTerms = Array(search.split(separator: " "))
            let joinedTerms = searchTerms.joined(separator: "%20")
            finalSearch += joinedTerms
        } else {
            finalSearch += search
        }
        return finalSearch
    }

    func loadData() async {
        guard let term = self.searchedTerm else {return}
        let string = "http://\(self.lang).wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exsentences=2&exlimit=1&titles=\(term)&explaintext=true"
        guard let url = URL(string: string) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted {$0.title < $1.title}
        } catch {
            print("Invalid data")
        }
        
    }
    
    var body: some View {
        NavigationView {
            List(pages, id: \.pageid) { page in
                VStack (spacing : 20){
                    Text(page.title).font(.system(.title, design: .rounded, weight: .semibold))
                    Text(page.extract)
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Wikipedia")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                }
            }
            .searchable(text: self.$search)
            .onSubmit(of: .search) {
                self.searchedTerm = convertSearch(self.search)
                print(self.searchedTerm!)
                Task{
                    await loadData()
                }
            }
        }
    }
}

struct WikiApp_Previews: PreviewProvider {
    static var previews: some View {
        WikiApp()
    }
}

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let extract: String
}
