//
//  Feedback.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation

struct Feedback: Codable {
    var userId: String //사용자 id
    var deviceName: String //기기 이름 ex.SM-F731
    var osVersion: String  //OS version
    var appVersion: String  //App version
    var contents: String //피드백 내용
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case deviceName = "device_name"
        case osVersion = "os_version"
        case appVersion = "app_version"
        case contents
    }
}
