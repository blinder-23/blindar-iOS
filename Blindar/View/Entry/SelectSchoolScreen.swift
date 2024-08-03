//
//  SelectSchoolScreen.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import SwiftUI
import SwiftData

var globalSchoolCode: Int = 0

struct SelectSchoolScreen: View {
    @EnvironmentObject var appStateVM: AppStateViewModel
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.modelContext) private var modelContext
    @StateObject private var schoolVM = SchoolViewModel()
    @State var query: String = ""
    var filteredSchools: [School] {
        if query.isEmpty {
            return schoolVM.schools
        } else {
            return schoolVM.schools.filter { $0.schoolName.contains(query) }
        }
    }
    @Query var savedSchools: [SchoolLocalData]
    
    var body: some View {
        NavigationStack {
            VStack {
                //헤더
                HStack {
                    Text("학교 선택")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.vertical, 20)
                //검색바
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white)
                    .frame(height: 60)
                    .overlay {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField(text: $query, prompt: Text("학교 이름 검색").foregroundStyle(.hexC6C6CA), label: {
                                EmptyView()
                            })
                        }
                        .padding()
                    }
                //학교 목록
                ScrollView {
                    ForEach(filteredSchools, id: \.schoolCode) { school in
                        VStack(alignment: .leading) {
                            VStack(spacing: 3) {
                                Text(school.schoolName)
                            }
                            .padding(.vertical)
                            Rectangle()
                                .frame(height: 0.3)
                        }
                        .onTapGesture {
                            query = school.schoolName
                            saveSchoolsToLocal(school: school)
                            globalSchoolCode = school.schoolCode
                            let newUser: User = User(userId: globalUid, schoolCode: globalSchoolCode, name: globalNickname)
                            userVM.user = newUser
                            //postUser 함수 호출
                            userVM.postUser(newUser: newUser)
                            appStateVM.appState = .postingUser
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            schoolVM.fetchSchools()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("UserRegistered"), object: nil, queue: .main) { _ in
                appStateVM.appState = .mainCalendarPage
            }
        }
    }
    
    private func saveSchoolsToLocal(school: School) {
        for savedSchool in savedSchools {
            modelContext.delete(savedSchool)
        }
        
        // Insert new school
        let schoolToSave = SchoolLocalData(schoolName: school.schoolName, schoolCode: school.schoolCode)
        modelContext.insert(schoolToSave)
        try? modelContext.save()
    }
}

#Preview {
    SelectSchoolScreen()
}
