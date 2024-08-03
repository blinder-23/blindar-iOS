//
//  FeedbackNavigationPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import SwiftUI

struct FeedbackNavigationPage: View {
    @EnvironmentObject var userVM: UserViewModel
    @StateObject var feedbackVM: FeedbackViewModel = FeedbackViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var newFeedback: Feedback = Feedback(userId: "", deviceName: "", osVersion: "", appVersion: "", contents: "")
    @State var contents: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    //헤더
                    Text("피드백 내용")
                    //입력창
                    TextEditor(text: $contents)
                        .padding(10)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                HStack(spacing: 10) {
                    //취소 버튼
                    Button(action: {
                        dismiss()
                    }, label: {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.hex00497B, lineWidth: 2)
                            .frame(height: 50)
                            .overlay {
                                Text("취소")
                                    .foregroundStyle(Color.white)
                                    .font(.title3)
                            }
                    })
                    //전송 버튼
                    Button(action: {
                        let deviceInfo = getDeviceInfo()
                        newFeedback = Feedback(userId: userVM.user.userId, deviceName: deviceInfo.deviceName, osVersion: deviceInfo.osVersion, appVersion: deviceInfo.osVersion, contents: contents)
                        //피드백 전송 함수 호출
                        feedbackVM.postFeedback(newFeedback: newFeedback)
                        dismiss()
                    }, label: {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.hex00497B)
                            .frame(height: 50)
                            .overlay {
                                Text("전송")                                    
                                    .foregroundStyle(Color.white)
                                    .font(.title3)
                            }
                    })
                }
            }
            .padding()
        }
        .navigationBarTitle(Text("피드백 작성"))
    }
}

#Preview {
    FeedbackNavigationPage()
}
