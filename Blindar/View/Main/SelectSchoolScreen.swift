//
//  SelectSchoolScreen.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import SwiftUI
import SwiftData

struct SelectSchoolScreen: View {
    @StateObject private var schoolVM = SchoolViewModel()
    @Environment(\.modelContext) private var modelContext
    //학교 리스트
    @State var schools: [School] = []
    
    var body: some View {
        VStack {
            Button(action: {
                schoolVM.fetchSchools()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            List {
                ForEach(schools, id: \.self) { school in
                    Text(school.school_name)
                }
            }
        }
        .onAppear {
            schoolVM.fetchSchools()
        }
    }
    
    private func saveToLocal(_ school: SchoolData) {
        modelContext.insert(school)
        try? modelContext.save()
    }
}

#Preview {
    SelectSchoolScreen(schools: [])
}
