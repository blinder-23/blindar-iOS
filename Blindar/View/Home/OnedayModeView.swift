//
//  OnedayModeView.swift
//  Blindar
//
//  Created by Suji Lee on 8/6/24.
//

import SwiftUI

struct OnedayModeView: View {
    @EnvironmentObject var uiManager: UIManager
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Binding var mealsForCurrentDate: MealLocalData?
    @Binding var schedulesForCurrentDate: [ScheduleLocalData]
    @Binding var memosForCurrentDate: [MemoLocalData]

    var body: some View {
        if uiManager.isPortrait {
                ScrollView {
                    //날짜 블록
                    VStack {
                        VStack {
                            // 현재 날짜
                            VStack(alignment: .leading) {
                                Text("입력한 날짜")
                                    .accessibilityAddTraits(.isHeader)
                                Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                                    .font(.title)
                            }
                            .padding()
                            VStack(alignment: .leading, spacing: 0) {
                                // 날짜입력
                                Text("날짜 입력")
                                    .accessibilityAddTraits(.isHeader)
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
                            }
                        }
                        HStack {
                            // 하루전, 오늘, 다음날 버튼
                            DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "하루 전")
                            DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "오늘")
                            DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "다음 날")
                        }
                    }
                    .frame(width: uiManager.isPortrait ? uiManager.screenWidth * 0.85 : uiManager.screenWidth * 0.45)
                    .padding()
                    .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
                    // 정보
                    VStack {
                        // 식단 뷰
                        MealContentsView(currentDate: $currentDate, selectedDate: $selectedDate, mealsForCurrentDate: $mealsForCurrentDate)
//                            .id("meal")
                        // 일정 뷰
                        ScheduleContentsView(currentDate: $currentDate, selectedDate: $selectedDate, schedulesForCurrentDate: $schedulesForCurrentDate, memosForCurrentDate: $memosForCurrentDate)
//                            .id("schedule")
                    }
                }
//                .accessibilityRotor("식단") {
//                    AccessibilityRotorEntry("식단", id: "meal")
//                }
//                .accessibilityRotor("학사일정") {
//                    AccessibilityRotorEntry("일정", id: "schedule")
//                }
        } else {
            HStack(alignment: .top) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("입력한 날짜")
                            .accessibilityHeading(.h1)
                        VStack(alignment: .leading) {
                            Text("입력한 날짜")
                            // 현재 날짜
                            Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                                .font(.title)
                        }
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        // 날짜입력
                        Text("날짜 입력")
                            .accessibilityHeading(.h1)
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
                    }
                    HStack {
                        // 하루전, 오늘, 다음날 버튼
                        DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "하루 전")
                        DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "오늘")
                        DateChangeButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "다음 날")
                    }
                }
                .frame(width: uiManager.isPortrait ? uiManager.screenWidth * 0.85 : uiManager.screenWidth * 0.45)                .padding()
                .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
                ScrollView {
                    // 정보
                    VStack {
                        // 식단 뷰
                        MealContentsView(currentDate: $currentDate, selectedDate: $selectedDate, mealsForCurrentDate: $mealsForCurrentDate)
                        // 일정 뷰
                        ScheduleContentsView(currentDate: $currentDate, selectedDate: $selectedDate, schedulesForCurrentDate: $schedulesForCurrentDate, memosForCurrentDate: $memosForCurrentDate)
                    }
                }
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
    OnedayModeView(currentDate: .constant(Date()), selectedDate: .constant(Date()), mealsForCurrentDate: .constant(nil), schedulesForCurrentDate: .constant([]), memosForCurrentDate: .constant([]))
}

