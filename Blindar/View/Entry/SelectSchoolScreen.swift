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
    var isEntry: Bool
    
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
                    if isEntry {
                        NavigationLink(destination: {
                            SelectNicknameScreen(schoolCode: school.schoolCode, schoolName: school.schoolName)
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
                    } else {
                        Button(action: {
                            let user: User = User(userId: globalUid, schoolCode: school.schoolCode, name: userVM.user?.name ?? "이름 정보 없음", schoolName: school.schoolName)
                            repostUserToServer(user: user)
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
        }
        .padding()
        .onAppear {
            schoolVM.fetchSchools()
        }
    }
    
    private func repostUserToServer(user: User) {
        userVM.tryStoreUserSchoolToFirebase(user: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    break
                case .finished:
                    userVM.saveUserInfoToUserDefaults(user: user)
                }
            }, receiveValue: {
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
