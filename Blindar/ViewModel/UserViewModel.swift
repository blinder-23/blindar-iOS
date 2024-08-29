//
//  UserViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine
import FirebaseDatabase

enum UserState {
    case isNotRegistered
    case isRegistered
    case isCheckingRegistration
}

class UserViewModel: ObservableObject {
    @Published var user: User?
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
    }
    
    func getUserInfoFromUserDefaults() -> User? {
        return UserDefaults.standard.getUser(forKey: "user")
    }
    
    func postUser(newUser: UserRequest) -> AnyPublisher<Void, Never> {
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
                    promise(.success(()))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func tryStoreUserToFirebase(user: User) -> Future<Void, Error> {
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
                        "school_name": user.schoolName ?? ""
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
    
    // 2. 사용자 학교 정보를 저장하는 함수
    func tryStoreUserSchoolToFirebase(user: User) -> Future<Void, Error> {
        return Future { promise in
            let schoolRef = self.firebaseDB.child("users").child(user.name).child("school_info")
            
            let schoolData: [String: Any] = [
                "school_code": user.schoolCode,
                "school_name": user.schoolName ?? ""
            ]
            
            schoolRef.setValue(schoolData) { error, _ in
                if let error = error {
                    // Handle error when setting value
                    promise(.failure(error))
                } else {
                    // Successfully stored school information
                    promise(.success(()))
                }
            }
        }
    }

    func tryDeleteUserFromFirebase(user: User) -> Future<Void, Error> {
            return Future { promise in
                let userRef = self.firebaseDB.child("users").child(user.name)
                
                userRef.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        if let owner = snapshot.childSnapshot(forPath: "owner").value as? String, owner == user.userId {
                            userRef.removeValue { error, _ in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                        } else {
                            let error = NSError(domain: "Owner does not match", code: 0, userInfo: nil)
                            promise(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "Username does not exist", code: 0, userInfo: nil)
                        promise(.failure(error))
                    }
                }
            }
        }
    
    //    func tryStoreUserToFirebase(user: User) -> Future<Void, Error> {
    //        return Future { promise in
    //            let userRef = self.firebaseDB.child("users").child(user.name)
    //            
    //            // Step 1: Check if the username already exists
    //            userRef.observeSingleEvent(of: .value) { snapshot in
    //                if snapshot.exists() {
    //                    // Username already exists, do not proceed to save
    //                    self.isNicknameDuplicated = true
    //                    let error = NSError(domain: "Username already exists", code: 0, userInfo: nil)
    //                    promise(.failure(error))
    //                } else {
    //                    // Step 2: Username does not exist, proceed to store the data
    //                    let userData: [String: Any] = [
    //                        "owner": user.userId,
    //                        "school_code": user.schoolCode,
    //                        "school_name": user.schoolName
    //                    ]
    //                    
    //                    userRef.setValue(userData) { error, _ in
    //                        if let error = error {
    //                            // Handle error when setting value
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
