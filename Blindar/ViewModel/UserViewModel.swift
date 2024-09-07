//
//  UserViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine

enum UserState {
    case isNotRegistered
    case isRegistered
}

class UserViewModel: ObservableObject {
    @Published var user: User?
    var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    var postUserCancellable: AnyCancellable?
    //닉네임 중복 검사 결과
    @Published var isNicknameDuplicated: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var userState: UserState = .isNotRegistered
    
    func saveUserInfoToUserDefaults(user: User) {
        UserDefaults.standard.setUser(user, forKey: "user")
    }
    
    func getUserInfoFromUserDefaults() -> User? {
        return UserDefaults.standard.getUser(forKey: "user")
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
    
    func removeUser(forKey key: String) {
        self.removeObject(forKey: key)
    }
}
