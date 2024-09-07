//
//  Memo.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

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
