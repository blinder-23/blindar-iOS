//
//  NutrientNavigationPage.swift
//  Blindar
//
//  Created by Suji Lee on 5/31/24.
//

import SwiftUI
import SwiftData

enum NutrientCategory {
    case calorie
    case PCF
    case others
    case ingredient
    case none
}

extension NutrientCategory {
    var font: Font {
        switch self {
        case .calorie:
            return .title2
        case .PCF:
            return .title3
        case .others:
            return .body
        case .ingredient:
            return .body
        case .none:
            return .body // 기본 값으로 설정
        }
    }
}

struct NutrientNavigationPage: View {
    @EnvironmentObject var mealVM: MealViewModel
    @Environment(\.modelContext) private var modelContext
    @Binding var currentDate: Date
    @Query var savedMeals: [MealLocalData]
    var mealtype: MealType
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                //날짜
                VStack {
                    Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                        .font(.title)
                }
                .padding(.top, 40)
                ScrollView {
                    if let meals = savedMeals.first(where: { $0.ymd == DateUtils.shared.getDateString(from: currentDate) && $0.mealTime == mealtype.rawValue }) {
                        VStack(spacing: 20) {
                            // 열량
                            VStack {
                                NutrientBlock(category: .calorie, label: "열량", value: "\(meals.calorie)kcal")
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 1)
                            }
                            // 탄단지
                            VStack {
                                ForEach(meals.nutrients.filter { ["탄수화물", "단백질", "지방"].contains($0.nutrient) }, id: \.self) { nutrient in
                                    NutrientBlock(category: .PCF, label: nutrient.nutrient, value: "\(nutrient.amount)\(nutrient.unit)")
                                }
                            }
                            // 기타 영양소
                            VStack {
                                ForEach(meals.nutrients.filter { !["탄수화물", "단백질", "지방"].contains($0.nutrient) }, id: \.self) { nutrient in
                                    NutrientBlock(category: .others, label: nutrient.nutrient, value: "\(nutrient.amount)\(nutrient.unit)")
                                }
                            }
                            .padding(.bottom, 20)
                            // 원산지 정보
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("원산지 정보")
                                        .font(.title2)
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .frame(height: 1)
                                }
                                ForEach(meals.origins, id: \.self) { origin in
                                    NutrientBlock(category: .ingredient, label: origin.ingredient, value: origin.origin)
                                }
                            }
                        }
                        .padding(.top, 20)
                    } else {
                        Text("관련 정보가 없습니다")
                            .font(.title3)
                    }
                }
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle(Text("영양 및 원산지 정보"))
    }
}

struct NutrientBlock: View {
    var category: NutrientCategory
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
        .font(category.font)
    }
}

#Preview {
    NutrientNavigationPage(currentDate: .constant(Date()), mealtype: .lunch)
}
