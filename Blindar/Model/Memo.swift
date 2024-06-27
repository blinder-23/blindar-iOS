//
//  Memo.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct Memo: Codable {
    var user_id: String //사용자 UID
    var date: String //yyyyMMdd
    var memo_id: String //메모 id
    var contents: String //수정할 일정 내용
}

//@Model
//struct MemoData {
//    @Attribute(.unique) var user_id: String //사용자 UID
//    var date: String //yyyyMMdd
//    @Attribute(.unique) var memo_id: String //메모 id
//    var contents: String //수정할 일정 내용
//    
//    init(user_id: String, date: String, memo_id: String, contents: String) {
//        self.user_id = user_id
//        self.date = date
//        self.memo_id = memo_id
//        self.contents = contents
//    }
//}
