//
//  BlindarApp.swift
//  Blindar
//
//  Created by Suji Lee on 7/23/24.
//

import SwiftUI
import SwiftData

@main
struct BlindarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MealLocalData.self,
            MemoLocalData.self,
            ScheduleLocalData.self,
            SchoolLocalData.self,
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
                .environmentObject(UIManager())
                .environmentObject(UserViewModel())
                .environmentObject(MealViewModel())
                .environmentObject(SchoolViewModel())
                .environmentObject(ScheduleViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
