//
//  MealContentsView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI

enum MealType: String, CaseIterable {
    case breakfast = "조식"
    case lunch = "중식"
    case dinner = "석식"
}

struct MealContentsView: View {
    @ObservedObject var mealVM: MealViewModel
    @State private var mealtype: MealType = .lunch
    var mealTypeHeader = ["조식", "중식", "석식"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //Swipe zone
                VStack(spacing: 20) {
                    //Header
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
                        }
                    }
                    .overlay(alignment: .bottom, content: {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    })
                    //Meal Info
                    ForEach(mealVM.selectedMeals, id: \.self) { meal in
                        Section(header: Text("Menu for \(meal.ymd)")) {
                            ForEach(meal.dishes, id: \.self) { dish in
                                Text(dish.menu)
                            }
                        }
                    }
                    VStack {
                        switch mealtype {
                        case .breakfast:
                            Text("조식")
                        case .lunch:
                            Text("중식")
                        case .dinner:
                            Text("석식")
                        }
                    }
                    .font(.title3)
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
                })
                //Nutrition Info Button
                NavigationLink {
                    NutrientNavigationPage()
                } label: {
                    Text("영양 정보 확인하기")
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .padding(.horizontal, 10)
                        .background(Color.hex00497B)
                        .background(in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .frame(width: screenWidth * 0.85)
            .padding()
            .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MealContentsView(mealVM: MealViewModel())
}
