//
//  Feedback.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation

struct Feedback: Codable {
    var user_id: String //사용자 id
    var device_name: String //기기 이름 ex.SM-F731
    var os_version: String  //OS version
    var app_version: String  //App version
    var contents: String //피드백 내용
}

