//
//  ContentView.swift
//  Blindar
//
//  Created by Suji Lee on 7/21/24.
//

import SwiftUI
import SwiftData
import FirebaseAuth

class UIManager: ObservableObject {
    @Published var isPortrait = UIDevice.current.orientation.isPortrait
    @Published var screenWidth = UIScreen.main.bounds.width
    @Published var screenHeight = UIScreen.main.bounds.height
    @Published var isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
}

struct ContentView: View {
    @EnvironmentObject var uiManager: UIManager
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
                MainPage()
            }
        }
        .onAppear {
            if checkDeviceType() == "iPhone" {
                uiManager.isPortrait = true
            } else if checkDeviceType() == "iPad" {
                uiManager.isPortrait = false
            }
            print(checkDeviceType())
            // 자동 로그인
            if let user = userVM.getUserInfoFromUserDefaults() {
                userVM.user = user
                userVM.userState = .isRegistered
            } else {
                userVM.userState = .isNotRegistered
            }
            // 초기 화면 크기 설정
            uiManager.screenWidth = UIScreen.main.bounds.width
            uiManager.screenHeight = UIScreen.main.bounds.height
            // VoiceOver 상태 감지 및 업데이트
            uiManager.isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        }
    }
    
    func checkDeviceType() -> String {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return "iPhone"
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return "iPad"
        } else {
            return "Unknown"
        }
    }
}

#Preview {
    ContentView()
}
