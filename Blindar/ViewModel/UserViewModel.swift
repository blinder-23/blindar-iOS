//
//  LoginViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User = User(userId: "", schoolCode: 0, name: "")
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    var postUserCancellable: AnyCancellable?
    
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
}
