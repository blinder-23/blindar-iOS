//
//  Meal.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

@Model
class MealLocalData {
    var ymd: String //yyyyMMdd 날짜 문자열
    var dishes: [Dish] //메뉴정보 배열
    var origins: [Origin] //원산지 정보 배열
    var nutrients: [Nutrient] //영상소 정보 배열
    var calorie: Float //칼로리 정보
    var mealTime: String //조식, 중식, 석식
    
    init(ymd: String, dishes: [Dish], origins: [Origin], nutrients: [Nutrient], calorie: Float, mealTime: String) {
        self.ymd = ymd
        self.dishes = dishes
        self.origins = origins
        self.nutrients = nutrients
        self.calorie = calorie
        self.mealTime = mealTime
    }
}

struct MealReqeust: Codable {
    var schoolCode: Int
    var year: Int
    var month: Int
}

struct MealResponse: Codable {
    let response: [Meal]
}

struct Meal: Codable, Hashable {
    var ymd: String //yyyyMMdd 날짜 문자열
    var dishes: [Dish] //메뉴정보 배열
    var origins: [Origin] //원산지 정보 배열
    var nutrients: [Nutrient] //영양소 정보 배열
    var calorie: Float //칼로리 정보
    var mealTime: String //조식, 중식, 석식
    
    enum CodingKeys: String, CodingKey {
        case mealTime = "meal_time"
        case ymd
        case dishes
        case origins
        case calorie
        case nutrients
    }
}

struct Dish: Codable, Hashable {
    var menu: String //메뉴 이름 (한글)
    var allergies: [String] //알러지 정보를 1~18까지의 문자열로 매핑
}

struct Origin: Codable, Hashable {
    var ingredient: String //재료 이름
    var origin: String //원산지
}

struct Nutrient: Codable, Hashable {
    var nutrient: String //영양소명 ex.탄수화물
    var unit: String //단위 ex.g, mg
    var amount: String //양
}
