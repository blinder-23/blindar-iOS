//
//  PostUserProgressView.swift
//  Blindar
//
//  Created by Suji Lee on 7/27/24.
//

import SwiftUI

struct PostingUserProgressView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        VStack(spacing: 50) {
            Text("회원 등록 중입니다")
            ProgressView()
                .frame(height: screenHeight * 0.5)
        }
    }
}

#Preview {
    PostingUserProgressView()
}
