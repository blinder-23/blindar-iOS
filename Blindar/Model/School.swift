//
//  Shcool.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct SchoolResponse: Codable {
    var message: String
    var responseCode: Int
    var data: [School]
}

struct School: Codable, Hashable {
    var school_name: String //학교 이름 (한글)
    var school_code: Int //NEIS API에서 제공하는 표준 학교 코드
}

@Model
class SchoolData {
    var school_name: String //학교 이름 (한글)
    
    init(school_name: String) {
        self.school_name = school_name
    }
}
