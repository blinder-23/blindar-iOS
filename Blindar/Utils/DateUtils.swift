//
//  DateUtils.swift
//  Blindar
//
//  Created by Suji Lee on 7/9/24.
//

import Foundation

func extractYearAndMonth(from date: Date) -> (year: Int, monthWithZero: String) {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let monthWithZero = String(format: "%02d", month) // 두 자리 문자열로 변환
    return (year, monthWithZero)
}

func configureDateFormatter() -> DateFormatter {
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
