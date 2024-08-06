//
//  MainCalendarPage.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData
import Combine

enum MainPageMode {
    case Calendar
    case OneDay
}

struct MainPage: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var schoolVM: SchoolViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Query var savedSchools: [SchoolLocalData]
    @State var currentDate: Date = Date()
    @State var selectedDate: Date = Date()
    @Query var savedMeals: [MealLocalData]
    @Query var savedSchedules: [ScheduleLocalData]
    @Query var savedMemos: [MemoLocalData]
    @State private var translation: CGFloat = 0
    @State var mealsForCurrentDate: MealLocalData?
    @State var schedulesForCurrentDate: [ScheduleLocalData] = []
    @State var mainPageMode: MainPageMode = .Calendar
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    //학교 표시 - 학교 선택 페이지 네비게이션 링크
                    NavigationLink(destination: {
                        SelectSchoolScreen()
                    }, label: {
                        if let school = schoolVM.getSchoolInfoFromUserDefaults() {
                            Text(school.schoolName)
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        } else {
                            Text("학교 정보 없음")
                        }
                    })
                }
                .padding(.bottom, 20)
                //뷰 모드
                VStack(spacing: 10) {
                    switch mainPageMode {
                    case .Calendar:
                        //달력 모드
                        ScrollView {
                            //달력
                            CalendarView(currentDate: $currentDate, selectedDate: $selectedDate)
                                .padding(.bottom)
                            //정보
                            VStack {
                                //식단 뷰
                                MealContentsView(currentDate: $currentDate, selectedDate: $selectedDate, mealsForCurrentDate: $mealsForCurrentDate)
                                //일정 뷰
                                ScheduleContentsView(currentDate: $currentDate, selectedDate: $selectedDate, schedulesForCurrentDate: $schedulesForCurrentDate)
                            }
                            .onAppear {
                                selectedDate = currentDate
                                //디버깅
                                //updateMealsForCurrentDate()
                            }
                            .onChange(of: selectedDate) { _ in
                                updateMealsAndSchedulesForCurrentDate()
                            }
                        }
                    case .OneDay:
                        OnedayModeView()
                    }
                }
            }
            .onAppear {
                currentDate = Date()
                selectedDate = Date()
            }
            .onChange(of: currentDate) { newDate in
                fetchMealsIfNeeded(for: newDate)
                fetchSchedulesIfNeeded(for: newDate)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: {
                        SettingPage()
                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    })
                })
            })
        }
    }
    
    private func updateMealsAndSchedulesForCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let selectedDateString = formatter.string(from: selectedDate)
        //식단 업데이트
        mealsForCurrentDate = savedMeals.first { $0.ymd == selectedDateString }
        //일정 업데이트
        schedulesForCurrentDate = savedSchedules.filter { $0.dateString == selectedDateString }
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
            if let school = schoolVM.getSchoolInfoFromUserDefaults() {
                mealVM.fetchMeals(schoolCode: school.schoolCode, year: year, month: month)
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
    }
    
    func fetchSchedulesIfNeeded(for date: Date) {
        let extractedDate = DateUtils.shared.extractYearAndMonth(from: date)
        let year = extractedDate.year
        let month = extractedDate.monthWithZero
        
        let monthExists = savedSchedules.contains { schedule in
            let schduleDateComponents = DateUtils.shared.extractYearAndMonth(from: schedule.dateString)
            return schduleDateComponents.year == year && schduleDateComponents.monthWithZero == month
        }
        
        if !monthExists {
            if let school = schoolVM.getSchoolInfoFromUserDefaults() {
                scheduleVM.fetcSchedules(schoolCode: school.schoolCode, year: year, month: month)
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            print("ScheduleFetch failed: \(error)")
                        }
                    }, receiveValue: { schedules in
                        for schedule in schedules {
                            let scheduleLocalData = ScheduleLocalData(
                                schoolCode: schedule.schoolCode,
                                id: schedule.id,
                                date: schedule.date,
                                schedule: schedule.scheduleInfo,
                                contents: schedule.contents,
                                dateString: DateUtils.shared.convertEpochToDateString(epoch: schedule.date)
                            )
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
}

#Preview {
    MainCalendarPage()
}
