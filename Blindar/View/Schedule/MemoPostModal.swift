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
    @EnvironmentObject var memoVM: MemoViewModel
    @Environment(\.dismiss) private var dismiss
    let currentDate = Date()
    @State var newMemo: Memo = Memo(userId: "", date: "", memoId: "", contents: "")
    @State private var contents = ""
    @State private var yyyyMMdddate = ""
    
    var body: some View {
        VStack(spacing: 40) {
            Text("메모 추가")
                .font(.title2)
            Text(configureDateFormatter.string(from: currentDate))
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
                    newMemo.date = compactDateFormatter.string(from: currentDate)
                    newMemo.contents = contents
                    postMemoToServer(newMemo: newMemo)
                        .sink(receiveValue: { newMemoId in
                            if let newMemoId = newMemoId {
                                let newMemoToLocal = MemoLocalData(userId: newMemo.userId, date: newMemo.date, memoId: newMemoId, contents: newMemo.contents)
                                postMemoToLocal(newMemoToLocal: newMemoToLocal)
                            }
                            dismiss()
                        })
                        .store(in: &memoVM.cancellables)
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
            newMemo.userId = userVM.user.userId
        }
    }
    
    func postMemoToServer(newMemo: Memo) -> AnyPublisher<String?, Never> {
        memoVM.postMemo(newMemo: newMemo)
    }
    
    func postMemoToLocal(newMemoToLocal: MemoLocalData) {
        if !savedMemos.contains(where: { $0.memoId == newMemoToLocal.memoId }) {
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
