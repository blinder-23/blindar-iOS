//
//  User.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct User: Codable {
    var user_id: String //Google Firebase UID
    var school_code: Int //NEIS API에서 제공하는 표준 학교 코드
    var name: String //유저 닉네임
}

@Model
class UserData {
    @Attribute(.unique) var user_id: String //Google Firebase UID
    var school_code: Int //NEIS API에서 제공하는 표준 학교 코드
    @Attribute(.unique) var name: String //유저 닉네임
    
    init(user_id: String, school_code: Int, name: String) {
        self.user_id = user_id
        self.school_code = school_code
        self.name = name
    }
}
