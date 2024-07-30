//
//  ScheduleContentsView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI

struct ScheduleContentsView: View {
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var memoVM: MemoViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //Header
                HStack {
                    Text("일정")
                        .font(.title2)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 5)
                }
                .overlay(alignment: .bottom, content: {
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(.gray)
                })
                //Schdule Info
                Text("일정 목록")
                    .font(.title3)
                //Memo List
                ForEach(memoVM.memos, id: \.memoId) { memo in
                    Text(memo.contents)
                }
                //Memo Edit Button
                NavigationLink {
                    MemoNavigationPage(memoVM: memoVM)
                } label: {
                    Text("메모 편집하기")
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .padding(.horizontal, 10)
                        .background(Color.hex00497B)
                        .background(in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .frame(width: screenWidth * 0.85)
            .padding()
            .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
        }
        .onAppear {
            //디버깅
            print("userId to fetch memos", userVM.user.userId)
//            memoVM.fetchMemos(userId: userVM.user.userId)
            memoVM.fetchMemos(userId: "TFAgDLyG3bhdeSB1it0uiAO2YYp2")

            
        }
    }
}

#Preview {
    ScheduleContentsView()
}
