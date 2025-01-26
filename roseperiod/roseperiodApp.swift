//
//  roseperiodApp.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI
import SwiftData

@main
struct roseperiodApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Period.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
