//
//  CalendarView.swift
//  Blindar
//
//  Created by Suji Lee on 8/6/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @State private var translation: CGFloat = 0
    
    var body: some View {
        let monthDates = generateMonthDates()
   
        VStack(spacing: 10) {
            //달력 헤더
            HStack(spacing: 70) {
                // 상단 년, 월
                Button(action: {
                    self.currentDate = Date()
                    self.selectedDate = Date()
                }, label: {
                    VStack {
                        Text(DateUtils.shared.yearFormatter.string(from: currentDate))
                        Text(DateUtils.shared.monthWithoutZeroFormatter.string(from: currentDate))
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.hex9DCAFF)
                    }
                })
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(Text("오늘 날짜는 \(DateUtils.shared.configureDateFormatter.string(from: Date()))입니다. 오늘을 선택된 날짜로 설정하기"))
                .accessibilityHint(Text("이중 탭하면 선택된 날짜를 오늘로 설정합니다"))
                // 월 이동 버튼
                HStack(spacing: 40) {
                    Button(action: {
                        self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .accessibilityLabel("이전 달 달력 보기")
                    Button(action: {
                        self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityLabel("다음 달 달력 보기")
                }
                .font(.headline)
                .foregroundStyle(Color.hex9DCAFF)
            }
            .offset(x: 70)
            .padding(.bottom)
                //달력
                VStack {
                    // 요일 헤더
                    HStack {
                        ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
                        }
                    }
                    .accessibilityHidden(true)
                    .padding(.bottom, 8)
                    // 달력 날짜들
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        ForEach(monthDates, id: \.self) { date in
                            Button(action: {
                                self.selectedDate = date
                                self.currentDate = date
                            }) {
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
                            }
                            .accessibilityLabel(
                                Calendar.current.isDate(Date(), inSameDayAs: date) && currentDate == date ?
                                Text("오늘 선택됨 \(Calendar.current.component(.day, from: date))일") :
                                (Calendar.current.isDate(Date(), inSameDayAs: date) ?
                                 Text("오늘 \(Calendar.current.component(.day, from: date))일") :
                                 (currentDate == date ?
                                  Text("선택됨 \(Calendar.current.component(.day, from: date))일") :
                                  Text("\(Calendar.current.component(.day, from: date))일")))
                            )
                            .accessibilityHint(Text("현재 날짜로 선택하려면 이중 탭하세요"))
                        }
                    }//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                self.translation = value.translation.width
//                            }
//                            .onEnded { value in
//                                if self.translation < -50 {
//                                    self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
//                                } else if self.translation > 50 {
//                                    self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
//                                }
//                                self.translation = 0
//                            }
//                    )
                }
        }
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
}

//struct CalendarView: View {
//    @Binding var currentDate: Date
//    @Binding var selectedDate: Date
//
//    var body: some View {
//        let monthDates = generateMonthDates()
//
//        VStack(spacing: 10) {
//            HStack(spacing: 70) {
//                VStack {
//                    Text(DateUtils.shared.yearFormatter.string(from: currentDate))
//                    Text(DateUtils.shared.monthWithoutZeroFormatter.string(from: currentDate))
//                        .font(.title)
//                        .fontWeight(.semibold)
//                        .foregroundStyle(Color.hex9DCAFF)
//                }
//                .onTapGesture {
//                    self.currentDate = Date()
//                }
//
//                HStack(spacing: 40) {
//                    Button(action: {
//                        self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .accessibilityLabel("Previous Month")
//                    }
//                    Button(action: {
//                        self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
//                    }) {
//                        Image(systemName: "chevron.right")
//                            .accessibilityLabel("Next Month")
//                    }
//                }
//                .font(.headline)
//                .foregroundStyle(Color.hex9DCAFF)
//            }
//            .offset(x: 70)
//            .padding(.bottom)
//
//            VStack {
//                HStack {
//                    ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
//                        Text(day)
//                            .frame(maxWidth: .infinity)
//                            .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .primary))
//                            .accessibilityHidden(true) // Hide weekdays from VoiceOver
//                    }
//                }
//                .padding(.bottom, 8)
//
//                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
//                    ForEach(monthDates, id: \.self) { date in
//                        Text("\(Calendar.current.component(.day, from: date))")
//                            .font(.title3)
//                            .padding(5)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(selectedDate == date ? Color.white.opacity(0.4) : Color.clear)
//                            .clipShape(Circle())
//                            .foregroundColor(isSameMonth(date: date) ? (isSaturday(date: date) ? .blue : (isSunday(date: date) ? .red : .primary)) : .gray)
//                            .overlay(
//                                Circle().stroke(isToday(date: date) ? Color.hex9DCAFF : Color.clear)
//                            )
//                            .onTapGesture {
//                                self.selectedDate = date
//                                self.currentDate = date
//                            }
//                            .accessibilityLabel("\(dateFormatter.string(from: date))")
//                            .accessibilityAddTraits(selectedDate == date ? .isSelected : .none)
//                    }
//                }
//            }
//        }
//    }
//
//    // Other methods remain unchanged...
//}
