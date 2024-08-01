//
//  LoginViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User = User(userId: "", schoolCode: 0, name: "")
    var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    var postUserCancellable: AnyCancellable?
    let firebaseDB = Firestore.firestore()
    //닉네임 중복 검사 결과 추가
    @Published var isNicknameDuplicated: Bool = false
    //닉네임 중복 검사 결과 메시지 추가
    @Published var nicknameCheckMessage: String?
    
    func postUser(newUser: User) {
        postUserCancellable = UserAPI.shared.postUser(newUser: newUser)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { userdata in
                self.user = userdata.response
                // 사용자 등록 성공 시 Notification 전송
                NotificationCenter.default.post(name: NSNotification.Name("UserRegistered"), object: nil)
            })
    }
    
    func cancelPostUser() {
        postUserCancellable?.cancel()
        postUserCancellable = nil
    }
    
    func checkNicknameDuplication(nickname: String) {
        firebaseDB.collection("users").whereField("name", isEqualTo: nickname).getDocuments { querySnapshot, error in
            if let error = error {
                self.nicknameCheckMessage = "Error checking nickname: \(error.localizedDescription)"
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                self.nicknameCheckMessage = "중복된 이름입니다"
                self.isNicknameDuplicated = true
            } else {
                self.nicknameCheckMessage = nil
                self.isNicknameDuplicated = false
            }
        }
    }
}
