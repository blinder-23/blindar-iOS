//
//  MemoEditModal.swift
//  Blindar
//
//  Created by Suji Lee on 7/30/24.
//

import SwiftUI
import SwiftData
import Combine

struct MemoEditModal: View {
    @Environment(\.modelContext) private var modelContext
    @Query var savedMemos: [MemoLocalData]
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var memoVM: MemoViewModel
    @Environment(\.dismiss) private var dismiss
    let currentDate = Date()
    @State var contents = ""
    @State var yyyyMMdddate = ""
    @State var localMemo: MemoLocalData
    
    var body: some View {
        VStack(spacing: 40) {
            Text("메모 편집")
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
                Button(action: { dismiss() }, label: {
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
                    yyyyMMdddate = DateUtils.shared.compactDateFormatter.string(from: currentDate)
                    editMemoOfServer()
                        .sink(receiveValue: {
                            editMemoOfLocal()
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
            contents = localMemo.contents
        }
    }
    
    func editMemoOfServer() -> AnyPublisher<Void, Never> {
        memoVM.editMemo(newMemo: Memo(userId: localMemo.userId, date: yyyyMMdddate, memoId: localMemo.memoId, contents: contents))
    }
    
    func editMemoOfLocal() {
        localMemo.contents = contents
        localMemo.date = yyyyMMdddate
        do {
            try modelContext.save()
        } catch {
            print("Failed to edit memo: \(error)")
        }
    }
}
