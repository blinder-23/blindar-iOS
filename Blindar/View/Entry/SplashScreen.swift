//
//  SplashScreen.swift
//  Blindar
//
//  Created by Suji Lee on 8/5/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image("Splash")
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen()
}
