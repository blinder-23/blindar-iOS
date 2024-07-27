//
//  PostUserProgressView.swift
//  Blindar
//
//  Created by Suji Lee on 7/27/24.
//

import SwiftUI

struct PostingUserProgressView: View {
    @EnvironmentObject var appStateVM: AppStateViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        VStack(spacing: 200) {
            ProgressView()
            Button(action: {
                userVM.cancelPostUser()
                appStateVM.appState = .selectShcoolScreen
            }, label: {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.hex00497B)
                    .frame(width: screenWidth * 0.9, height: 55)
                    .overlay {
                        Text("취소")
                            .font(.headline)
                    }
            })
        }
    }
}

#Preview {
    PostingUserProgressView()
}
