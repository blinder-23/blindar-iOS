//
//  DateUtils.swift
//  Blindar
//
//  Created by Suji Lee on 7/9/24.
//

import Foundation

import Foundation

struct DateUtils {
    static let shared = DateUtils()

    private init() {}

    func extractYearAndMonth(from date: Date) -> (year: Int, monthWithZero: String) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let monthWithZero = String(format: "%02d", month)
        return (year, monthWithZero)
    }

    func extractYearAndMonth(from ymd: String) -> (year: Int, monthWithZero: String) {
        let year = Int(ymd.prefix(4)) ?? 0
        let monthWithZero = String(ymd.dropFirst(4).prefix(2))
        return (year, monthWithZero)
    }

    var configureDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어로 설정
        formatter.dateFormat = "yyyy년 MM월 dd일 (EE)" // 연, 월, 일, 요일 형식
        return formatter
    }

    var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY"
        return formatter
    }

    var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M"
        return formatter
    }

    var compactDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
}
