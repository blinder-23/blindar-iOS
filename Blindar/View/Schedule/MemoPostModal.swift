//
//  MemoModal.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import SwiftUI
import SwiftData
import Combine

struct MemoPostModal: View {
    @Environment(\.modelContext) private var modelContext
    @Query var savedMemos: [MemoLocalData]
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @State var newMemo: Memo = Memo(userId: "", date: "", contents: "")
    @State private var contents = ""
    @State private var yyyyMMdddate = ""
    @Binding var memosForCurrentDate: [MemoLocalData]
    
    var body: some View {
        VStack(spacing: 40) {
            Text("메모 추가")
                .font(.title2)
            Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                .font(.title)
            TextEditor(text: $contents)
                .padding()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
            HStack(spacing: 10) {
                Button(action: {
                    dismiss()
                }, label: {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 50)
                        .overlay {
                            Text("취소")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                        }
                })
                Button(action: {
                    newMemo.date = DateUtils.shared.compactDateFormatter.string(from: currentDate)
                    newMemo.contents = contents
                    if let user = userVM.getUserInfoFromUserDefaults() {
                        //로컬에 메모 저장
                        let newMemoToLocal: MemoLocalData = MemoLocalData(id: newMemo.id, date: newMemo.date, userId: newMemo.userId, contents: newMemo.contents)
                        postMemoToLocal(newMemoToLocal: newMemoToLocal)
                    } else {
                        print("no user")
                    }
                    dismiss()
                }, label: {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.hex00497B)
                        .frame(height: 50)
                        .overlay {
                            Text("저장")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                        }
                })
            }
        }
        .padding()
        .onAppear {
            newMemo.userId = userVM.user.id
        }
        .onDisappear {
            //메모 업데이트
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let selectedDateString = formatter.string(from: selectedDate)
            memosForCurrentDate = savedMemos.filter { $0.date == selectedDateString}
        }
    }
    
    func postMemoToLocal(newMemoToLocal: MemoLocalData) {
        if !savedMemos.contains(where: { $0.id == newMemoToLocal.id }) {
            modelContext.insert(newMemoToLocal)
            do {
                try modelContext.save()
                print("Memo saved successfully. Current saved memos count: \(savedMemos.count)")
            } catch {
                print("Failed to save memo: \(error)")
            }
        } else {
            print("Memo already exists in the local database.")
        }
    }
}
