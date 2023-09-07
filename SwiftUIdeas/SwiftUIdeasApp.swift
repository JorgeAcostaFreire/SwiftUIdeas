//
//  SwiftUIdeasApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI

@main
struct SwiftUIdeasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
