//
//  User.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var schoolCode: Int //NEIS API에서 제공하는 표준 학교 코드
    var schoolName: String
}
