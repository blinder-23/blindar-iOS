//
//  Memo.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct MemoResponse: Codable {
    let response: [Memo]?
    let message: String?
    let responseCode: Int?
    var memoId: String?
    
    enum CodingKeys: String, CodingKey {
        case memoId = "memo_id"
        case response
        case message
        case responseCode
    }
}

struct Memo: Codable {
    var userId: String //사용자 UID
    var date: String //yyyyMMdd
    var memoId: String //메모 id
    var contents: String //수정할 일정 내용
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case memoId = "memo_id"
        case date
        case contents
    }
}

@Model 
final public class MemoLocalData: Identifiable {
    var userId: String
    var date: String
    var memoId: String
    var contents: String
    
    init(userId: String, date: String, memoId: String, contents: String) {
        self.userId = userId
        self.date = date
        self.memoId = memoId
        self.contents = contents
    }
}
