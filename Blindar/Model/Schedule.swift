//
//  Schedule.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct Schedule: Codable {
    var schoolCode: Int //학교 코드
    var id: Int //일정 아이디(정수)
    var date: Int //UNIX epoch로 나타낸 날짜 (정수)
    var schedule: String //일정 제목
    var contents: String //일정 내용
    
    enum CodingKeys: String, CodingKey {
        case schoolCode = "school_code"
        case id
        case date
        case schedule
        case contents
    }
}

@Model
class ScheduleLocalData {
    var schoolCode: Int //학교 코드
    @Attribute(.unique) var id: Int //일정 아이디(정수)
    var date: Int //UNIX epoch로 나타낸 날짜 (정수)
    var schedule: String //일정 제목
    var contents: String //일정 내용
    
    init(schoolCode: Int, id: Int, date: Int, schedule: String, contents: String) {
        self.schoolCode = schoolCode
        self.id = id
        self.date = date
        self.schedule = schedule
        self.contents = contents
    }
}
