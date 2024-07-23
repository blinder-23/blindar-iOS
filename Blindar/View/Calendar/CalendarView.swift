//
//  CalendarView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var mealVM: MealViewModel
    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            CalendarHeader(currentDate: $currentDate)
            CustomCalendar(mealVM: mealVM, currentDate: $currentDate)
                .gesture(DragGesture().onEnded { value in
                    if value.translation.width < 0 {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    } else if value.translation.width > 0 {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }
                })
        }
        .padding(.horizontal)
    }
}

struct CalendarHeader: View {
    @Binding var currentDate: Date
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 70) {
                //년, 월
                VStack {
                    Text("\(currentDate, formatter: yearFormatter)")
                    Text("\(currentDate, formatter: monthFormatter)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.hex9DCAFF)
                }
                .onTapGesture {
                    currentDate = Date()
                }
                //월 이동 버튼
                HStack(spacing: 40) {
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.system(size: 25, weight: .bold)) // 고정 폰트 크기
                .foregroundStyle(Color.hex9DCAFF)
            }
            .offset(x: 70)
            //요일 표시
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.title3) // 고정 폰트 크기
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .white))
                }
            }
        }
    }
}

struct CustomCalendar: View {
    @ObservedObject var mealVM: MealViewModel
    @Binding var currentDate: Date
    
    private var currentMonth: Int {
        Calendar.current.component(.month, from: currentDate)
    }
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    
    private var daysInMonth: [[Date]] {
        var days = [Date]()
        let calendar = Calendar.current
        _ = calendar.range(of: .day, in: .month, for: currentDate)!
        
        // First day of the month
        var startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        // Adjust to the previous Sunday
        while calendar.component(.weekday, from: startDate) != 1 {
            startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
        }
        
        for _ in 0..<42 { // 6 weeks * 7 days = 42 cells
            days.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        // Split into 6 weeks
        var weeks = [[Date]]()
        for i in stride(from: 0, to: days.count, by: 7) {
            let week = Array(days[i..<i+7])
            weeks.append(week)
        }
        
        return weeks
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(daysInMonth, id: \.self) { week in
                HStack {
                    ForEach(week, id: \.self) { date in
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(4)
                            .foregroundColor(color(for: date))
                            .overlay(todayOverlay(for: date))
                    }
                }
            }
        }
    }
    
    private func color(for date: Date) -> Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .month) {
            if weekday == 1 {
                return .red
            } else if weekday == 7 {
                return .blue
            } else {
                return .white
            }
        } else {
            return .gray
        }
    }
    
    private func todayOverlay(for date: Date) -> some View {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return Circle()
                .stroke(Color.hex9DCAFF, lineWidth: 2)
        } else {
            return Circle()
                .stroke(Color.clear, lineWidth: 2)
        }
    }
    
//    private func dateFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
    
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd" // 날짜 형식을 서버에서 받는 형식에 맞춤
        return formatter.string(from: date)
    }
}

//#Preview {
//    CalendarView(currentDate: <#T##Binding<Date>#>)
//}
