//
//  ContentView.swift
//  Blindar
//
//  Created by Suji Lee on 7/21/24.
//

import SwiftUI
import SwiftData
import FirebaseAuth

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var schoolVM: SchoolViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @Query var savedMeals: [MealLocalData]
    
    var body: some View {
        Group {
            switch userVM.userState {
            case .isCheckingRegistration:
                SplashScreen()
            case .isNotRegistered:
                LoginPage()
            case .isRegistered:
                MainCalendarPage()
            }
        }
        .onAppear {
            //자동 로그인
            if userVM.getUserInfoFromUserDefaults() != nil {
                userVM.userState = .isRegistered
            } else {
                userVM.userState = .isNotRegistered
            }
        }
    }
}

#Preview {
    ContentView()
}
