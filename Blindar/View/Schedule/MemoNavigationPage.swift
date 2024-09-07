//
//  MemoNavigationPage.swift
//  Blindar
//
//  Created by Suji Lee on 6/1/24.
//

import SwiftUI
import SwiftData

struct MemoNavigationPage: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @State var isMemoPostModalPresented: Bool = false
    @State var isMemoEditModalPresented: Bool = false
    @State var selectedMemo: MemoLocalData? = nil
    @Query(sort: \MemoLocalData.date, order: .forward) var savedMemos: [MemoLocalData]
    @Binding var memosForCurrentDate: [MemoLocalData]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                        .font(.title)
                    Spacer()
                }
                .padding(.vertical, 40)
                Button(action: {
                    isMemoPostModalPresented = true
                }, label: {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.hex00497B)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        .overlay {
                            Text("메모 추가하기")
                                .foregroundStyle(.white)
                        }
                })
                ScrollView {
                    ForEach(memosForCurrentDate, id: \.id) { memo in
                        MemoBlock(localMemo: memo) {
                            selectedMemo = memo
                            isMemoEditModalPresented = true
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isMemoPostModalPresented, content: {
            MemoPostModal(currentDate: $currentDate, selectedDate: $selectedDate, memosForCurrentDate: $memosForCurrentDate)
                .presentationDetents([.large, .fraction(0.7)])
        })
        .sheet(item: $selectedMemo, content: { memo in
            MemoEditModal(currentDate: $currentDate, selectedDate: $selectedDate, localMemo: memo, memosForCurrentDate: $memosForCurrentDate)
                .presentationDetents([.large, .fraction(0.7)])
        })
    }
}

struct MemoBlock: View {
    @Environment(\.modelContext) private var modelContext
    @State var isAlertPresented: Bool = false
    var localMemo: MemoLocalData
    var onEdit: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text(localMemo.contents)
                Spacer()
                Button(action: { onEdit() }, label: {
                    Image(systemName: "pencil")
                })
                Button(action: { isAlertPresented = true }, label: {
                    Image(systemName: "trash")
                })
            }
            .padding(.vertical)
            Rectangle()
                .frame(height: 0.3)
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("메모 삭제"), message: Text("메모를 삭제하시겠습니까?"), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("삭제"), action: {
                deleteMemo()
            }))
        }
    }
    
    func deleteMemo() {
        // 로컬 메모 삭제
        modelContext.delete(localMemo)
    }
}
