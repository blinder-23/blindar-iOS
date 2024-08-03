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
    @Environment(\.window) var window: UIWindow?
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 200) {
                //스플래시 앱 아이콘
                Image("SplashAppIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight * 0.3)
                //로그인 버튼
                Button(action: {
                    appleLogin()
                }, label: {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white, lineWidth: 1.5)
                        .frame(width: screenWidth * 0.85, height: 55)
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
                    SelectNicknameScreen()
                })
            )
        }
        .onChange(of: appleLoginCoordinator?.isLoggedIn, initial: false, {
            self.isLoggedIn = true
        })
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window)
        appleLoginCoordinator?.startAppleLogin()
    }
}
