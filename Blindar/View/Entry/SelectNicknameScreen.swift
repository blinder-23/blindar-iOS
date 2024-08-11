//
//  NicknameNavigationPAge.swift
//  Blindar
//
//  Created by Suji Lee on 7/23/24.
//

import SwiftUI
import FirebaseDatabase

var globalNickname: String = ""

struct SelectNicknameScreen: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var nickname: String = ""
    @State var isNicknameProper: Bool = true
    @State var isDuplicated: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 200) {
                VStack(spacing: 50) {
                    //헤더
                    HStack {
                        Text("닉네임 입력")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    //입력창
                    VStack(alignment: .leading) {
                        Text("한글 15자, 영문 및 숫자 30자")
                            .foregroundColor(isNicknameProper ? .white : Color.hexFFB4AB)
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isNicknameProper ? Color.white : Color.hexFFB4AB, lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width * 0.94, height: 60)
                            .overlay {
                                HStack {
                                    TextField("한글 15자, 영문 및 숫자 30자", text: $nickname)
                                        .onChange(of: nickname) { newValue in
                                            validateNickname(newValue)
                                        }
                                }
                                .padding(.horizontal, 8)
                            }
                        //경고메세지
                        if !isNicknameProper {
                            Text("조건에 맞지 않는 이름입니다")
                                .foregroundColor(Color.hexFFB4AB)
                        }
                        if isDuplicated {
                            Text("중복된 이름입니다")
                                .foregroundColor(Color.hexFFB4AB)
                        }
                    }
                }
                //회원가입 버튼
                Button(action: {
                    let newUser: User = User(userId: globalUid, schoolCode: globalSchoolCode, name: globalNickname)
                    postUserToServer(newUser: newUser)
                    userVM.saveUserInfoToUserDefaults(user: User(userId: globalUid, schoolCode: globalSchoolCode, name: globalNickname, schoolName: globalSchoolName))
                }, label: {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width * 0.94, height: 60)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 6,
                                bottomLeadingRadius: 6,
                                bottomTrailingRadius: 6,
                                topTrailingRadius: 6
                            )
                        )
                        .foregroundColor(.hex42474E)
                        .overlay {
                            Text("다음")
                                .font(.title2)
                                .foregroundStyle(Color.white)
                        }
                })
            }
            .padding()
        }
        .onDisappear {
            globalNickname = nickname
        }
    }
    
    private func validateNickname(_ nickname: String) {
        let maxLength = 30
        let maxKoreanLength = 15
        let koreanCount = nickname.filter { $0.isKoreanCharacter }.count
        let englishNumberCount = nickname.filter { $0.isEnglishOrNumber }.count
        
        if koreanCount > maxKoreanLength || englishNumberCount > maxLength || nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || nickname.contains(" ") {
            isNicknameProper = false
        } else {
            isNicknameProper = true
        }
    }
    
    func postUserToServer(newUser: User) {
        userVM.postUser(newUser: newUser)
            .sink(receiveValue: { _ in
                userVM.userState = .isRegistered
            })
            .store(in: &userVM.cancellables)
    }
}

extension Character {
    var isKoreanCharacter: Bool {
        return (self >= "\u{AC00}" && self <= "\u{D7A3}") || (self >= "\u{1100}" && self <= "\u{11FF}") || (self >= "\u{3130}" && self <= "\u{318F}")
    }
    
    var isEnglishOrNumber: Bool {
        return (self >= "A" && self <= "Z") || (self >= "a" && self <= "z") || (self >= "0" && self <= "9")
    }
}

#Preview {
    SelectNicknameScreen()
}
