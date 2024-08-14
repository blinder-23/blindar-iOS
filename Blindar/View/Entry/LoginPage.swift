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
    @Environment(\.window) var window: UIWindow?
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    @State var isLoggedIn = false
    
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
                        appleLogin()
                    }, label: {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 1.5)
                            .frame(width: uiManager.screenWidth * 0.85, height: 55)
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
                .padding(20)
                .background(
                    NavigationLink("", isActive: $isLoggedIn, destination: {
                        SelectSchoolScreen()
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
                            appleLogin()
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
                        SelectSchoolScreen()
                    })
                    .accessibilityHidden(true)
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window) {
            // Completion handler called after login UI is dismissed
                self.isLoggedIn = true
        }
        appleLoginCoordinator?.startAppleLogin()
    }
}
