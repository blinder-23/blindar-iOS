//
//  CalendarView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var mealVM: MealViewModel
    @Binding var currentDate: Date
    @State private var selectedDate: Date? = nil
    @State private var translation: CGFloat = 0
    @Query var savedMeals: [MealLocalData]
    
    var body: some View {
        let monthDates = generateMonthDates()
        let year = DateUtils.shared.yearFormatter.string(from: currentDate)
        let monthWithoutZero = DateUtils.shared.monthWithoutZeroFormatter.string(from: currentDate)
        
        VStack(spacing: 10) {
            HStack(spacing: 70) {
                // 상단 년, 월
                VStack {
                    Text(year)
                    Text(monthWithoutZero)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.hex9DCAFF)
                }
                .onTapGesture {
                    self.currentDate = Date()
                }
                // 월 이동 버튼
                HStack(spacing: 40) {
                    Button(action: {
                        self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: {
                        self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.headline)
                .foregroundStyle(Color.hex9DCAFF)
            }
            .offset(x: 70)
            
            // 요일 헤더
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
                }
            }
            
            // 달력 날짜들
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(monthDates, id: \.self) { date in
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.title3)
                        .padding(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(selectedDate == date ? Color.white.opacity(0.4) : Color.clear)
                        .clipShape(Circle())
                        .foregroundColor(isSameMonth(date: date) ? (isSaturday(date: date) ? .blue : (isSunday(date: date) ? .red : .primary)) : .gray)
                        .overlay(
                            Circle().stroke(isToday(date: date) ? Color.hex9DCAFF : Color.clear)
                        )
                        .onTapGesture {
                            self.selectedDate = date
                            self.currentDate = date
                            print(DateUtils.shared.getDateString(from: date))
                            fetchMealsIfNeeded(for: date)
                        }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation.width
                    }
                    .onEnded { value in
                        if self.translation < -50 {
                            self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                        } else if self.translation > 50 {
                            self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                        }
                        self.translation = 0
                    }
            )
        }
        .padding()
    }
    
    // 오늘 날짜 여부 확인 함수
    func isToday(date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    // 같은 달인지 확인하는 함수
    func isSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    // 일요일 여부 확인 함수
    func isSunday(date: Date) -> Bool {
        return Calendar.current.component(.weekday, from: date) == 1
    }
    
    // 토요일 여부 확인 함수
    func isSaturday(date: Date) -> Bool {
        return Calendar.current.component(.weekday, from: date) == 7
    }
    
    // 현재 월의 날짜들을 생성하는 함수
    func generateMonthDates() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        
        var dates: [Date] = []
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        let daysInPreviousMonth = firstWeekday
        
        for i in stride(from: -daysInPreviousMonth, to: 0, by: 1) {
            if let date = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        while dates.count % 7 != 0 {
            if let date = calendar.date(byAdding: .day, value: dates.count - daysInPreviousMonth, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    // 사버로부터 식단 데이터를 받아 로컬에 저장하는 함수
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
