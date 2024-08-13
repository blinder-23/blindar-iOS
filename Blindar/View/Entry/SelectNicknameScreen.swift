//
//  NicknameNavigationPAge.swift
//  Blindar
//
//  Created by Suji Lee on 7/23/24.
//

import SwiftUI
import Combine
import SwiftData

struct SelectNicknameScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query var savedMeals: [MealLocalData]
    @Query var savedSchedules: [ScheduleLocalData]
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var schoolVM: SchoolViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @State var nickname: String = ""
    @State var isNicknameProper: Bool = true
    @State var isDuplicated: Bool = false
    let schoolCode: Int
    let schoolName: String
    
    var body: some View {
        VStack {
            VStack(spacing: 50) {
                //헤더
                HStack {
                    Text("닉네임 입력")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                //입력창
                VStack(alignment: .leading) {
                    Text("한글 15자, 영문 및 숫자 30자")
                        .foregroundColor(isNicknameProper ? .white : Color.hexFFB4AB)
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isNicknameProper ? Color.white : Color.hexFFB4AB, lineWidth: 1)
                        .frame(width: UIScreen.main.bounds.width * 0.94, height: 60)
                        .overlay {
                            HStack {
                                TextField("한글 15자, 영문 및 숫자 30자", text: $nickname)
                                    .onChange(of: nickname) { newValue in
                                        validateNickname(newValue)
                                        isDuplicated = false // 텍스트 필드가 변경될 때 중복 체크 상태 초기화
                                    }
                            }
                            .padding(.horizontal, 8)
                        }
                    //경고메세지
                    if !isNicknameProper {
                        Text("조건에 맞지 않는 이름입니다")
                            .foregroundColor(Color.hexFFB4AB)
                    }
                    //경고메세지
                    if isDuplicated {
                        Text("중복된 이름입니다")
                            .foregroundColor(Color.hexFFB4AB)
                    }
                }
            }
            //다음 버튼
            Button(action: {
                let newUser: User = User(userId: globalUid, schoolCode: schoolCode, name: nickname, schoolName: schoolName)
                postUserToServer(user: newUser)
            }, label: {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.94, height: 60)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 6,
                            bottomLeadingRadius: 6,
                            bottomTrailingRadius: 6,
                            topTrailingRadius: 6
                        )
                    )
                    .foregroundColor(.hex42474E)
                    .overlay {
                        Text("다음")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                    }
            })
            Spacer()
        }
        .padding()
        .padding(.top)
    }
    
    private func validateNickname(_ nickname: String) {
        let maxLength = 30
        let maxKoreanLength = 15
        let koreanCount = nickname.filter { $0.isKoreanCharacter }.count
        let englishNumberCount = nickname.filter { $0.isEnglishOrNumber }.count
        
        if nickname.isEmpty {
            isNicknameProper = true // 빈 문자열일 경우 경고 메시지 표시하지 않음
        } else if koreanCount > maxKoreanLength || englishNumberCount > maxLength || nickname.contains(" ") {
            isNicknameProper = false
        } else {
            isNicknameProper = true
        }
    }
    
    func postUserToServer(user: User) {
        userVM.tryStoreUserToFirebase(user: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    isDuplicated = true
                    break
                case .finished:
                    userVM.saveUserInfoToUserDefaults(user: user)
                }
            }, receiveValue: {
                if !isDuplicated {
                    userVM.postUser(newUser: UserRequest(userId: user.userId, schoolCode: user.schoolCode, name: user.name))
                        .sink(receiveValue: { _ in
                            // 저장된 유저 정보가 올바른지 확인
                            if let savedUser = userVM.getUserInfoFromUserDefaults(),
                               savedUser.schoolCode != 0,
                               savedUser.schoolName != "" {
                                
                                // Refresh functions 실행
                                refreshMeals(for: Date())
                                refreshSchedules(for: Date())
                                userVM.user = user
                                // 모든 작업이 완료된 후 상태 변경
                                userVM.userState = .isRegistered
                            }
                            dismiss()
                        })
                        .store(in: &userVM.cancellables)
                }
            })
            .store(in: &userVM.cancellables)
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

extension Character {
    var isKoreanCharacter: Bool {
        return (self >= "\u{AC00}" && self <= "\u{D7A3}") || (self >= "\u{1100}" && self <= "\u{11FF}") || (self >= "\u{3130}" && self <= "\u{318F}")
    }
    
    var isEnglishOrNumber: Bool {
        return (self >= "A" && self <= "Z") || (self >= "a" && self <= "z") || (self >= "0" && self <= "9")
    }
}
