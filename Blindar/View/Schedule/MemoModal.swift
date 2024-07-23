//
//  MemoModal.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import SwiftUI

struct MemoModal: View {
    @Environment(\.dismiss) private var dismiss
    let currentDate = Date()
    let dateFormatter = configureDateFormatter()
    @State private var text = ""
    
    var body: some View {
            VStack(spacing: 40) {
                //헤더
                Text("메모 추가")
                    .font(.title2)
                //날짜
                Text(dateFormatter.string(from: currentDate))
                    .font(.title)
                //입력창
                TextEditor(text: $text)
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
                    //저장 버튼
                    Button(action: {
                        
                    }, label: {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.blue)
                            .frame(height: 50)
                            .overlay {
                                Text("저장")
                                    .font(.title3)
                            }
                    })
                }
            }
            .padding()
    }
}

#Preview {
    MemoModal()
}
