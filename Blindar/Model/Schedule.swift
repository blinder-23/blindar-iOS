//
//  Schedule.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct Schedule: Codable {
    var school_code: Int //학교 코드
    var id: Int //일정 아이디(정수)
    var date: Int //UNIX epoch로 나타낸 날짜 (정수)
    var schedule: String //일정 제목
    var contents: String //일정 내용
}

@Model
class ScheduleData {
    var school_code: Int //학교 코드
    @Attribute(.unique) var id: Int //일정 아이디(정수)
    var date: Int //UNIX epoch로 나타낸 날짜 (정수)
    var schedule: String //일정 제목
    var contents: String //일정 내용
    
    init(school_code: Int, id: Int, date: Int, schedule: String, contents: String) {
        self.school_code = school_code
        self.id = id
        self.date = date
        self.schedule = schedule
        self.contents = contents
    }
}
