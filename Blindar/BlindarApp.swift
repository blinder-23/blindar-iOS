//
//  BlindarApp.swift
//  Blindar
//
//  Created by Suji Lee on 7/23/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices

//Firebase 연동을 위한 delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct BlindarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserLocalData.self,
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
                .environmentObject(AppStateViewModel())
                .environmentObject(UserViewModel())
                .environmentObject(MemoViewModel())
                .environmentObject(MealViewModel())
                .environmentObject(SchoolViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
