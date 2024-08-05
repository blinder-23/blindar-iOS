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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userVM: UserViewModel
    @StateObject private var schoolVM = SchoolViewModel()
    @State var query: String = ""
    var filteredSchools: [School] {
        if query.isEmpty {
            return schoolVM.schools
        } else {
            return schoolVM.schools.filter { $0.schoolName.contains(query) }
        }
    }
    
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
                            globalSchoolCode = school.schoolCode
                            saveSchoolToUserDefaults()
                            let newUser: User = User(userId: globalUid, schoolCode: globalSchoolCode, name: globalNickname)
                            postUserToServer(newUser: newUser)
                            dismiss()
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            schoolVM.fetchSchools()
        }
    }
    
    func saveSchoolToUserDefaults() {
        schoolVM.saveSchoolInfoToUserDefaults(school: School(schoolName: query, schoolCode: globalSchoolCode))
    }
    
    func postUserToServer(newUser: User) {
        userVM.postUser(newUser: newUser)
            .sink(receiveValue: { _ in
                userVM.userState = .isRegistered
            })
            .store(in: &userVM.cancellables)
    }
}

#Preview {
    SelectSchoolScreen()
}
