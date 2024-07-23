//
//  Shcool.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct SchoolResponse: Codable {
    let message: String
    let responseCode: Int
    let data: [School]
}

// Define the refined data structure
struct School: Codable, Hashable {
    let schoolName: String
    let schoolCode: Int
    
    enum CodingKeys: String, CodingKey {
        case schoolCode = "school_code"
        case schoolName = "school_name"
    }
}

@Model
class SchoolLocalData {
    var schoolName: String //학교 이름 (한글)
    var schoolCode: Int
    
    init(schoolName: String, schoolCode: Int) {
        self.schoolName = schoolName
        self.schoolCode = schoolCode
    }
}
