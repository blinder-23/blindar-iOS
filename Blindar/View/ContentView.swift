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
            MainPage()
            //            switch userVM.userState {
            //            case .isCheckingRegistration:
            //                SplashScreen()
            //            case .isNotRegistered:
            //                LoginPage()
            //            case .isRegistered:
            //                MainPage()
            //            }
        }
        .onAppear {
            // 자동 로그인
            if userVM.getUserInfoFromUserDefaults() != nil {
                userVM.userState = .isRegistered
            } else {
                userVM.userState = .isNotRegistered
            }
            // 초기 화면 크기 설정
            uiManager.isPortrait = UIDevice.current.orientation.isPortrait
            uiManager.screenWidth = UIScreen.main.bounds.width
            uiManager.screenHeight = UIScreen.main.bounds.height
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // 화면 회전 시 화면 크기와 방향 업데이트
            uiManager.isPortrait = UIDevice.current.orientation.isPortrait
            uiManager.screenWidth = UIScreen.main.bounds.width
            uiManager.screenHeight = UIScreen.main.bounds.height
        }
    }
}

#Preview {
    ContentView()
}
