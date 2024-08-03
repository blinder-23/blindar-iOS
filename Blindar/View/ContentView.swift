//
//  ContentView.swift
//  Blindar
//
//  Created by Suji Lee on 7/21/24.
//

import SwiftUI
import SwiftData

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

enum AppState {
    case loginPage
    case selectShcoolScreen
    case postingUser
    case mainCalendarPage
}

class AppStateViewModel: ObservableObject {
    @Published var appState: AppState = .loginPage
}

struct ContentView: View {
    @EnvironmentObject var appStateVM: AppStateViewModel
    
    var body: some View {
        switch appStateVM.appState {
        case .loginPage:
            LoginPage()
        case .selectShcoolScreen:
            SelectSchoolScreen()
        case .postingUser:
            PostingUserProgressView()
        case .mainCalendarPage:
            MainCalendarPage()
        }
    }
}

#Preview {
    ContentView()
}
