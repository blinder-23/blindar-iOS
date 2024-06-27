//
//  Meal.swift
//  Blindar
//
//  Created by Suji Lee on 6/26/24.
//

import Foundation
import SwiftData

struct Meal: Codable {
    var ymd: String //yyyyMMdd 날짜 문자열
    var dishes: [Dish] //메뉴정보 배열
    var origins: [Origin] //원산지 정보 배열
    var nutrients: [Nutrient] //영상소 정보 배열
    var calorie: Float //칼로리 정보
    var meal_time: String //조식, 중식, 석식
}

@Model
class MealData {
    var ymd: String //yyyyMMdd 날짜 문자열
    var dishes: [Dish] //메뉴정보 배열
    var origins: [Origin] //원산지 정보 배열
    var nutrients: [Nutrient] //영상소 정보 배열
    var calorie: Float //칼로리 정보
    var meal_time: String //조식, 중식, 석식
    
    init(ymd: String, dishes: [Dish], origins: [Origin], nutrients: [Nutrient], calorie: Float, meal_time: String) {
        self.ymd = ymd
        self.dishes = dishes
        self.origins = origins
        self.nutrients = nutrients
        self.calorie = calorie
        self.meal_time = meal_time
    }
}

struct Dish: Codable {
    var menu: String //메뉴 이름 (한글)
    var allergies: [String] //알러지 정보를 1~18까지의 문자열로 매핑
    /*
     1. 난류
     2. 우유
     3. 메밀
     4. 땅콩
     5. 대두
     6. 밀
     
     7. 고등어
     8. 게
     9. 새우
     10. 돼지고기
     11. 복숭아
     12. 토마토
     
     13. 아황산염
     14. 호두
     15. 닭고기
     16. 쇠고기
     17. 오징어
     18. 조개류(굴,전복,홍합 등
     */
}

@Model
class DishData {
    var menu: String //메뉴 이름 (한글)
    var allergies: [String] //알러지 정보를 1~18까지의 문자열로 매핑
    
    init(menu: String, allergies: [String]) {
        self.menu = menu
        self.allergies = allergies
    }
}

struct Origin: Codable {
    var ingredient: String //재료 이름
    var origin: String //원산지
}

@Model
class OriginData {
    var ingredient: String //재료 이름
    var origin: String //원산지
    
    init(ingredient: String, origin: String) {
        self.ingredient = ingredient
        self.origin = origin
    }
}

struct Nutrient: Codable {
    var nutrient: String //영상소명 ex.탄수화물
    var unit: String //다나위 ex.g, mg
    var amount: String //양
}

@Model
class NutrientData {
    var nutrient: String //영상소명 ex.탄수화물
    var unit: String //다나위 ex.g, mg
    var amount: String //양
    
    init(nutrient: String, unit: String, amount: String) {
        self.nutrient = nutrient
        self.unit = unit
        self.amount = amount
    }
}
