//
//  BlindarApp.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData

@main
struct BlindarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserData.self,
            MealData.self,
            ScheduleData.self,
            SchoolData.self,
//            MemoData.self,
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
