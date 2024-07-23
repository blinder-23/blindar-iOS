//
//  MemoNavigationPage.swift
//  Blindar
//
//  Created by Suji Lee on 6/1/24.
//

import SwiftUI

struct MemoNavigationPage: View {
    @ObservedObject var memoVM: MemoViewModel
    let currentDate = Date()
    let dateFormatter = configureDateFormatter()
    
    var body: some View {
        NavigationStack {
            VStack {
                //헤더
                HStack {
                    Text(dateFormatter.string(from: currentDate))
                        .font(.title)
                    Spacer()
                }
                .padding(.vertical, 40)
                //추가 버튼
                Button(action: {
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.blue)
                        .frame(width: screenWidth * 0.9, height: 50)
                        .overlay {
                            Text("메모 추가하기")
                        }
                })
                //메모 리스트
                ScrollView {
                    MemoBlock()
                    MemoBlock()
                }
            }
            .padding()
        }
    }
}

struct MemoBlock: View {
    @State var isMemoModalPresented: Bool = false
    @State var isAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text("sadlkfjasldkjfalsdkjflaskdjflaskdjflsakdjflskdjfalskdjflaskdjflakdjfalsdkjfalskdjaflksdjf")
            Spacer()
                Button(action: {
                    isMemoModalPresented = true
                }, label: {
                    Image(systemName: "pencil")
                })
                Button(action: {
                    isAlertPresented = true
                }, label: {
                    Image(systemName: "trash")
                })
            }
            .padding(.vertical)
            Rectangle()
                .frame(height: 0.3)
        }
        .sheet(isPresented: $isMemoModalPresented, content: {
            MemoModal()
                .presentationDetents([.large, .fraction(0.7)])

        })
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("메모 삭제"), message: Text("메모를 삭제하시겠습니까?"), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("삭제"), action: {
                //메모 삭제 함수 호출
            }))
        }
    }
}


#Preview {
    MemoNavigationPage(memoVM: MemoViewModel())
}
