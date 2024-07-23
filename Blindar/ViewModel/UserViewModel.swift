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
    
    func postUser(newUser: User) {
        //디버깅
        print("postUser func called")
        UserAPI.shared.postMemo(newUser: newUser)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { userdata in
                //디버깅
                print("userdata from server : ", userdata)
                self.user = userdata
                //디버깅
                print("new user : ", self.user)
            })
            .store(in: &cancellables)
    }
}
