//
//  LoginPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/23/24.
//

import Foundation
import SwiftUI
import SwiftData

struct LoginPage: View {
    @EnvironmentObject var uiManager: UIManager
    @State var isLoggedIn = false
    @Binding var displayView: DisplayView
    
    var body: some View {
        NavigationView {
            if uiManager.isPortrait {
                VStack(spacing: 200) {
                    Image("SplashAppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: uiManager.screenHeight * 0.3)
                        .accessibilityHidden(true)
                    Button(action: {
                        login()
                    }, label: {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 1.5)
                            .frame(width: uiManager.screenWidth * 0.85, height: 55)
                            .overlay {
                                HStack {
                                    Text("시작하기")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                            }
                    })
                }
                .padding(20)
                .background(
                    NavigationLink("", isActive: $isLoggedIn, destination: {
                        SelectSchoolScreen(displayView: $displayView)
                    })
                    .accessibilityHidden(true)
                )
            } else {
                HStack {
                    VStack {
                        Image("SplashAppIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: uiManager.screenHeight * 0.3)
                            .accessibilityLabel(Text("블린더"))
                    }
                    .frame(width: uiManager.screenWidth * 0.45)
                    VStack {
                        Button(action: {
                            login()
                        }, label: {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white, lineWidth: 1.5)
                                .frame(width: uiManager.isPortrait ? uiManager.screenWidth * 0.85 : uiManager.screenWidth * 0.45, height: 55)
                                .overlay {
                                    HStack {
                                        Image(systemName: "apple.logo")
                                        Text("Apple로 시작하기")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                }
                        })
                    }
                }
                .background(
                    NavigationLink("", isActive: $isLoggedIn, destination: {
                        SelectSchoolScreen(displayView: $displayView)
                    })
                    .accessibilityHidden(true)
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func login() {
        self.isLoggedIn = true
    }
}
