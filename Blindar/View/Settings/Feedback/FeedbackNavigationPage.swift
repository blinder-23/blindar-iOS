//
//  FeedbackNavigationPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import SwiftUI

struct FeedbackNavigationPage: View {
    @Environment(\.dismiss) private var dismiss
    @State var contents: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                //입력창
                TextEditor(text: $contents)
                    .padding()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                HStack(spacing: 10) {
                    //취소 버튼
                    Button(action: {
                        dismiss()
                    }, label: {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 1)
                            .frame(height: 50)
                            .overlay {
                                Text("취소")
                                    .font(.title3)
                            }
                    })
                    //전송 버튼
                    Button(action: {
                        
                    }, label: {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.blue)
                            .frame(height: 50)
                            .overlay {
                                Text("전송")
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
