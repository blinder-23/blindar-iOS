//
//  MealContentsView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData

enum MealType: String, CaseIterable {
    case breakfast = "조식"
    case lunch = "중식"
    case dinner = "석식"
}

struct MealContentsView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var mealtype: MealType = .lunch
    var mealTypeHeader = ["조식", "중식", "석식"]
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Query var savedMeals: [MealLocalData]
    @Binding var mealsForCurrentDate: MealLocalData?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //Swipe zone
                VStack(spacing: 20) {
                    //헤더
                    HStack {
                        ForEach(MealType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .font(.title2)
                                .fontWeight(mealtype == type ? .bold : .regular)
                                .foregroundColor(mealtype == type ? .white : .gray)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 5)
                                .overlay(alignment: .bottom, content: {
                                    if mealtype == type {
                                        Rectangle()
                                            .frame(height: 3)
                                    }
                                })
                                .onTapGesture {
                                    mealtype = type
                                    //디버깅
//                                    updateMealsForCurrentDate()
                                }
                        }
                    }
                    .overlay(alignment: .bottom, content: {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    })
                    // 식단 리스트
                    if let meals = mealsForCurrentDate {
                        VStack {
                            ForEach(meals.dishes, id: \.self) { dish in
                                Text(dish.menu)
                                    .font(.title3)
                                    .padding(.vertical, 3)
                            }
                        }
                    } else {
                        Text("식단 정보가 없습니다")
                            .font(.title3)
                    }
                }
                .gesture(DragGesture().onEnded { value in
                    let allCases = MealType.allCases
                    if value.translation.width > 0 {
                        if let currentIndex = allCases.firstIndex(of: mealtype),
                           currentIndex > 0 {
                            mealtype = allCases[currentIndex - 1]
                        }
                    } else if value.translation.width < 0 {
                        if let currentIndex = allCases.firstIndex(of: mealtype),
                           currentIndex < allCases.count - 1 {
                            mealtype = allCases[currentIndex + 1]
                        }
                    }
                    //디버깅
//                    updateMealsForCurrentDate()
                })
                //영양 정보 확인하기 버튼
                NavigationLink {
                    NutrientNavigationPage(currentDate: $currentDate, mealtype: mealtype)
                } label: {
                    Text("영양 정보 확인하기")
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .padding(.horizontal, 10)
                        .background(Color.hex00497B)
                        .background(in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.85)
            .padding()
            .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
