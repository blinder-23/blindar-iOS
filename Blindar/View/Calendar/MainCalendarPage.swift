//
//  MainCalendarPage.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData
import Combine

struct MainCalendarPage: View {
    @EnvironmentObject var schoolVM: SchoolViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var savedSchools: [SchoolLocalData]
    @State var currentDate: Date = Date()
    @Query var savedMeals: [MealLocalData]
    
    var body: some View {
        NavigationStack {
            VStack {
                CalendarView(currentDate: $currentDate)
                ScrollView {
                    MealContentsView(currentDate: $currentDate)
                }
            }
            .onAppear {
                fetchMealsIfNeeded(for: currentDate)
            }
            .onChange(of: currentDate) { newDate in
                fetchMealsIfNeeded(for: newDate)
            }
        }
        .padding(.top, 20)
        //        .navigationTitle(Text(schoolVM.schools.first?.schoolName ?? ""))
    }
    
    func fetchMealsIfNeeded(for date: Date) {
        let extractedDate = DateUtils.shared.extractYearAndMonth(from: date)
        let year = extractedDate.year
        let month = extractedDate.monthWithZero
        
        let monthExists = savedMeals.contains { meal in
            let mealDateComponents = DateUtils.shared.extractYearAndMonth(from: meal.ymd)
            return mealDateComponents.year == year && mealDateComponents.monthWithZero == month
        }
        
        if !monthExists {
            mealVM.fetchMeals(schoolCode: 7380110, year: year, month: month)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Fetch failed: \(error)")
                    }
                }, receiveValue: { meals in
                    for meal in meals {
                        let mealLocalData = MealLocalData(
                            ymd: meal.ymd,
                            dishes: meal.dishes,
                            origins: meal.origins,
                            nutrients: meal.nutrients,
                            calorie: meal.calorie,
                            mealTime: meal.mealTime
                        )
                        modelContext.insert(mealLocalData)
                    }
                    try? modelContext.save()
                })
                .store(in: &mealVM.cancellables)
        }
    }
}

#Preview {
    MainCalendarPage()
}
