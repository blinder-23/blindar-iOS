//
//  User.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct User: Codable {
    var userId: String //Google Firebase UID
    var schoolCode: Int //NEIS API에서 제공하는 표준 학교 코드
    var name: String //유저 닉네임
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case schoolCode = "school_code"
        case name
    }
}

@Model
class UserLocalData {
    @Attribute(.unique) var userId: String //Google Firebase UID
    var schoolCode: Int //NEIS API에서 제공하는 표준 학교 코드
    var name: String //유저 닉네임
    
    init(userId: String, schoolCode: Int, name: String, email: String, platform: String) {
        self.userId = userId
        self.schoolCode = schoolCode
        self.name = name
    }
}
