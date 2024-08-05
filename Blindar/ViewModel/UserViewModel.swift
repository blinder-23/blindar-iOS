//
//  UserViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine
import FirebaseFirestore

enum UserState {
    case isNotRegistered
    case isRegistered
    case isCheckingRegistration
}

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
    @Published var isLoggedIn: Bool = false
    @Published var userState: UserState = .isCheckingRegistration
    
    func saveUserInfoToUserDefaults(user: User) {
        UserDefaults.standard.setUser(user, forKey: "user")
        userState = .isRegistered
    }
    
    func getUserInfoFromUserDefaults() -> User? {
        return UserDefaults.standard.getUser(forKey: "user")
    }
    
    func postUser(newUser: User) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            UserAPI.shared.postUser(newUser: newUser)                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        promise(.success(()))
                    case .finished:
                        break
                    }
                }, receiveValue: { data in
                    self.saveUserInfoToUserDefaults(user: data.response)
                    promise(.success(()))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
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

extension UserDefaults {
    func setUser(_ user: User, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(user)
            self.set(data, forKey: key)
        } catch {
            print("Unable to encode User: \(error)")
        }
    }
    
    func getUser(forKey key: String) -> User? {
        if let data = self.data(forKey: key) {
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                print("Unable to decode User: \(error)")
            }
        }
        return nil
    }
}
