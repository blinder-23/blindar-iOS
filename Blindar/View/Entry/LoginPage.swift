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
    @Environment(\.modelContext) private var context
    @Environment(\.window) var window: UIWindow?
    @State private var appleLoginCoordinator: AppleAuthCoordinator?

    var body: some View {
        VStack {
            Button(action: {
                appleLogin()
            }, label: {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.white)
                    .overlay {
                        Text("애플 로그인")
                    }
            })
        }
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window)
        appleLoginCoordinator?.startAppleLogin()
    }
}
