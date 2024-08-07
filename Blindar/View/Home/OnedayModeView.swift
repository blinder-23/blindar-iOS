//
//  OnedayModeView.swift
//  Blindar
//
//  Created by Suji Lee on 8/6/24.
//

import SwiftUI

struct OnedayModeView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Binding var mealsForCurrentDate: MealLocalData?
    @Binding var schedulesForCurrentDate: [ScheduleLocalData]
    @State var isProperDate: Bool = true

    var body: some View {
        VStack {
            // 원데이모드 UI
            VStack {
                VStack {
                    // 입력된 날짜
                    Text("입력한 날짜")
                    // 현재 날짜
                    Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                        .font(.title)
                }
                VStack {
                    // 날짜입력
                    Text("날짜 입력")
                    // 날짜입력창 yyyy.MM.dd
                    DatePicker("날짜 입력", selection: $currentDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white)
                                .frame(height: 200)
                        )
                        .onChange(of: currentDate) { newDate in
                            // 선택된 날짜를 currentDate에 반영
                            currentDate = newDate
                            selectedDate = newDate
                        }
                    // 날짜 필드 검증 메세지
                    if !isProperDate {
                        Text("잘못된 날짜입니다")
                            .foregroundStyle(Color.hexBA1A1A)
                    }
                }
                HStack {
                    // 하루전, 오늘, 다음날 버튼
                    DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "하루 전")
                    DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "오늘")
                    DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "다음 날")
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.85)
            .padding()
            .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
            // 정보
            VStack {
                // 식단 뷰
                MealContentsView(currentDate: $currentDate, selectedDate: $selectedDate, mealsForCurrentDate: $mealsForCurrentDate)
                // 일정 뷰
                ScheduleContentsView(currentDate: $currentDate, selectedDate: $selectedDate, schedulesForCurrentDate: $schedulesForCurrentDate)
            }
        }
    }
}

struct DateChangeButton: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    var labelString: String
    
    var body: some View {
        Button(action: {
            if labelString == "하루 전" {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                selectedDate = currentDate
            } else if labelString == "오늘" {
                currentDate = Date()
                selectedDate = Date()
            } else if labelString == "다음 날" {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                selectedDate = currentDate
            }
        }, label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 40)
                .overlay {
                    Text(labelString)
                        .foregroundColor(.white)
                }
        })
    }
}

#Preview {
    OnedayModeView(currentDate: .constant(Date()), selectedDate: .constant(Date()), mealsForCurrentDate: .constant(MealLocalData(ymd: "", dishes: [], origins: [], nutrients: [], calorie: 0, mealTime: "")), schedulesForCurrentDate: .constant([]))
}
