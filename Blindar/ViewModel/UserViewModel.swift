//
//  UserViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseDatabase

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
    let firebaseDB = Database.database().reference()
    //닉네임 중복 검사 결과
    @Published var isNicknameDuplicated: Bool = false
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
            UserAPI.shared.postUser(newUser: newUser)
                .receive(on: DispatchQueue.main)
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
                    self.storeUserWithCombine(username: newUser.name, userId: newUser.userId)
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func tryStoreUse(user: User) -> Future<Void, Error> {
        return Future { promise in
            let userRef = self.firebaseDB.child("users").child(user.name)
            
            // Step 1: Check if the username already exists
            userRef.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    // Username already exists, do not proceed to save
                    self.isNicknameDuplicated = true
                    let error = NSError(domain: "Username already exists", code: 0, userInfo: nil)
                    promise(.failure(error))
                } else {
                    // Step 2: Username does not exist, proceed to store the data
                    let userData: [String: Any] = [
                        "owner": user.userId,
                        "school_code": user.schoolCode,
                        "school_name": user.schoolName
                    ]
                    
                    userRef.setValue(userData) { error, _ in
                        if let error = error {
                            // Handle error when setting value
                            promise(.failure(error))
                        } else {
                            // Successfully stored user
                            self.isNicknameDuplicated = false
                            promise(.success(()))
                        }
                    }
                }
            }
        }
    }
    
    // Firestore에 사용자 이름 저장
//    func tryStoreUsername(username: String, userId: String) -> Future<Void, Error> {
//        return Future { promise in
//            let userRef = self.firebaseDB.child("users").child(username).child("owner")
//            
//            // Check if the username already exists
//            userRef.observeSingleEvent(of: .value) { snapshot in
//                if snapshot.exists() {
//                    // Username already exists
//                    self.isNicknameDuplicated = true
//                    promise(.failure(NSError(domain: "Username already exists", code: 0, userInfo: nil)))
//                } else {
//                    // Username does not exist, proceed to store the userId
//                    userRef.setValue(userId) { error, _ in
//                        if let error = error {
//                            print("Failed to store user: \(error.localizedDescription)")
//                            promise(.failure(error))
//                        } else {
//                            // Successfully stored user
//                            self.isNicknameDuplicated = false
//                            promise(.success(()))
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func storeUserWithCombine(user: User) {
        tryStoreUse(user: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to store username: \(error.localizedDescription)")
                case .finished:
                    print("Successfully stored username")
                }
            }, receiveValue: {
                print("User has been successfully stored in the database.")
            })
            .store(in: &cancellables)
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
