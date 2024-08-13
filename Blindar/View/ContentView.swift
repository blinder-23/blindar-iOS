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
            // 자동 로그인
            if let user = userVM.getUserInfoFromUserDefaults() {
                userVM.user = user
                userVM.userState = .isRegistered
            } else {
                userVM.userState = .isNotRegistered
            }
            // 초기 화면 크기 설정
            uiManager.isPortrait = UIDevice.current.orientation.isPortrait
            uiManager.screenWidth = UIScreen.main.bounds.width
            uiManager.screenHeight = UIScreen.main.bounds.height
            // VoiceOver 상태 감지 및 업데이트
            uiManager.isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
            //            NotificationCenter.default.addObserver(forName: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil, queue: .main) { _ in
            //                uiManager.isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
            //            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // 화면 회전 시 화면 크기와 방향 업데이트
            uiManager.isPortrait = UIDevice.current.orientation.isPortrait
            uiManager.screenWidth = UIScreen.main.bounds.width
            uiManager.screenHeight = UIScreen.main.bounds.height
        }
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)) { _ in
            // VoiceOver 상태 변경 감지 및 업데이트
            uiManager.isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        }
    }
}

#Preview {
    ContentView()
}
