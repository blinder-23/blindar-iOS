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
                VStack(alignment: .leading) {
                    // 현재 날짜
                    Text("입력한 날짜")
                        .accessibilityAddTraits(.isHeader)
                    Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                        .font(.title2)
                        .padding(.bottom)
                    // 날짜입력
                    Text("날짜 입력")
                        .accessibilityAddTraits(.isHeader)
                    VStack {
                        // 날짜입력창 yyyy.MM.dd
                        DatePicker("날짜 입력", selection: $currentDate, displayedComponents: [.date])
                            .frame(width: uiManager.screenWidth * 0.85, height: 200)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white)
                            )
                            .onChange(of: currentDate) { newDate in
                                // 선택된 날짜를 currentDate에 반영
                                currentDate = newDate
                                selectedDate = newDate
                            }
                        HStack {
                            // 하루전, 오늘, 다음날 버튼
                            PreviousDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "하루 전")
                            CurrentDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "오늘")
                            NextDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "다음 날")
                        }
                    }
                }
                .frame(width: uiManager.isPortrait ? uiManager.screenWidth * 0.85 : uiManager.screenWidth * 0.45)
                .padding()
                .background(Color.hex2E2E2E, in: RoundedRectangle(cornerRadius: 16))
                // 정보
                VStack {
                    // 식단 뷰
                    MealContentsView(currentDate: $currentDate, selectedDate: $selectedDate, mealsForCurrentDate: $mealsForCurrentDate)
                    // 일정 뷰
                    ScheduleContentsView(currentDate: $currentDate, selectedDate: $selectedDate, schedulesForCurrentDate: $schedulesForCurrentDate, memosForCurrentDate: $memosForCurrentDate)
                }
            }
        } else {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    // 현재 날짜
                    Text("입력한 날짜")
                        .accessibilityAddTraits(.isHeader)
                    Text(DateUtils.shared.configureDateFormatter.string(from: currentDate))
                        .font(.title2)
                        .padding(.bottom)
                    // 날짜입력
                    Text("날짜 입력")
                        .accessibilityAddTraits(.isHeader)
                    VStack {
                        // 날짜입력창 yyyy.MM.dd
                        DatePicker("날짜 입력", selection: $currentDate, displayedComponents: [.date])
                            .frame(width: uiManager.screenWidth * 0.45, height: 200)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white)
                            )
                            .onChange(of: currentDate) { newDate in
                                // 선택된 날짜를 currentDate에 반영
                                currentDate = newDate
                                selectedDate = newDate
                            }
                        HStack {
                            // 하루 전, 오늘, 다음 날 버튼
                            PreviousDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "하루 전")
                            CurrentDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "오늘")
                            NextDateButton(currentDate: $currentDate, selectedDate: $selectedDate, labelString: "다음 날")
                        }
                    }
                }
                .frame(width: uiManager.isPortrait ? uiManager.screenWidth * 0.85 : uiManager.screenWidth * 0.45)
                .padding()
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

struct PreviousDateButton: View {
    @EnvironmentObject var uiManager: UIManager
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    var labelString: String
    
    var body: some View {
        Button(action: {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            selectedDate = currentDate
        }, label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 40)
                .overlay {
                    Text(labelString)
                        .foregroundColor(.white)
                }
        })
        .accessibilityHint(Text("현재 날짜의 하루 전인 \(DateUtils.shared.configureDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate))로 이동하려면 이중 탭 하세요"))
    }
}

struct CurrentDateButton: View {
    @EnvironmentObject var uiManager: UIManager
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    var labelString: String
    
    var body: some View {
        Button(action: {
            currentDate = Date()
            selectedDate = Date()
        }, label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 40)
                .overlay {
                    Text(labelString)
                        .foregroundColor(.white)
                }
        })
        .accessibilityHint(Text("오늘 날짜 \(DateUtils.shared.configureDateFormatter.string(from: Date()))로 이동하려면 이중 탭 하세요"))
    }
}

struct NextDateButton: View {
    @EnvironmentObject var uiManager: UIManager
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    var labelString: String
    
    var body: some View {
        Button(action: {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            selectedDate = currentDate
        }, label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 40)
                .overlay {
                    Text(labelString)
                        .foregroundColor(.white)
                }
        })
        .accessibilityHint(Text("현재 날짜의 다음 날인 \(DateUtils.shared.configureDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate))로 이동하려면 이중 탭 하세요"))
    }
}


#Preview {
    OnedayModeView(currentDate: .constant(Date()), selectedDate: .constant(Date()), mealsForCurrentDate: .constant(nil), schedulesForCurrentDate: .constant([]), memosForCurrentDate: .constant([]))
}
