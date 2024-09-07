//
//  SelectSchoolScreen.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import SwiftUI
import SwiftData

struct SelectSchoolScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query var savedMeals: [MealLocalData]
    @Query var savedSchedules: [ScheduleLocalData]
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var uiManager: UIManager
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var schoolVM: SchoolViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    var schoolCode: Int = 0
    var schoolName: String = ""
    @State var isSchoolSelected = false
    @State var query: String = ""
    var filteredSchools: [School] {
        if query.isEmpty {
            return schoolVM.schools
        } else {
            return schoolVM.schools.filter { $0.schoolName.contains(query) }
        }
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("학교 선택")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.vertical, 20)
            
            // Search Bar
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white)
                .frame(height: 60)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .accessibilityHidden(true)
                        TextField(text: $query, prompt: Text("학교 이름 검색").foregroundStyle(.hexC6C6CA), label: {
                            EmptyView()
                        })
                    }
                    .padding()
                }
            
            // School List
            ScrollView {
                ForEach(filteredSchools, id: \.schoolCode) { school in
                        Button(action: {
                            //유저 저오 로컬에 저장
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(school.schoolName)
                                    .padding(.vertical)
                                Rectangle()
                                    .frame(height: 0.3)
                            }
                            .foregroundColor(.white)
                        })
                        .accessibilityLabel(Text(school.schoolName))
                }
            }
        }
        .padding()
        .onAppear {
            schoolVM.fetchSchools()
        }
    }
    
    func refreshMeals(for date: Date) {
        let extractedDate = DateUtils.shared.extractYearAndMonth(from: date)
        let year = extractedDate.year
        let month = extractedDate.monthWithZero
        
        for meal in savedMeals {
            modelContext.delete(meal)
        }
        
        try? modelContext.save()
        
        if let user = userVM.getUserInfoFromUserDefaults() {
            mealVM.fetchMeals(schoolCode: user.schoolCode, year: year, month: month)
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
        } else {
            print("cannot find school code")
        }
    }
    
    func refreshSchedules(for date: Date) {
        let extractedDate = DateUtils.shared.extractYearAndMonth(from: date)
        let year = extractedDate.year
        let month = extractedDate.monthWithZero
        
        for schedule in savedSchedules {
            modelContext.delete(schedule)
        }
        
        try? modelContext.save()
        
        if let user = userVM.getUserInfoFromUserDefaults() {
            scheduleVM.fetcSchedules(schoolCode: user.schoolCode, year: year, month: month)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Fetch failed: \(error)")
                    }
                }, receiveValue: { schedules in
                    for schedule in schedules {
                        let scheduleLocalData = ScheduleLocalData(schoolCode: schedule.schoolCode, id: schedule.id, date: schedule.date, schedule: schedule.scheduleInfo, contents: schedule.contents, dateString: DateUtils.shared.convertEpochToDateString(epoch: schedule.date))
                        modelContext.insert(scheduleLocalData)
                    }
                    try? modelContext.save()
                })
                .store(in: &scheduleVM.cancellables)
        } else {
            print("cannot find school code")
        }
    }
}
