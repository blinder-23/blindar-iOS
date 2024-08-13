//
//  SelectSchoolScreen.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import SwiftUI
import SwiftData

struct SelectSchoolScreen: View {
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
                    }
                }
            }
            .padding()
        .onAppear {
            schoolVM.fetchSchools()
        }
    }
}

#Preview {
    SelectSchoolScreen()
}
