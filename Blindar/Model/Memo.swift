//
//  Memo.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct Memo: Identifiable {
    var id: String = UUID().uuidString
    var userId: String
    var date: String
    var contents: String
}

@Model
final public class MemoLocalData: Identifiable {
    @Attribute(.unique) public var id: String
    var userId: String
    var date: String
    var contents: String
    
    init(id: String, date: String, userId: String, contents: String) {
        self.id = id
        self.date = date
        self.userId = userId
        self.contents = contents
    }
}
