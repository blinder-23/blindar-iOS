//
//  SchoolViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import Combine
import SwiftUI

class SchoolViewModel: ObservableObject {
    @Published var schools: [School] = []
    @Published var selectedSchool: School = School(schoolName: "", schoolCode: 0)
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func saveSchoolInfoToUserDefaults(school: School) {
        UserDefaults.standard.setSchool(school, forKey: "school")
    }
    
    func getSchoolInfoFromUserDefaults() -> School? {
        return UserDefaults.standard.getSchool(forKey: "school")
    }
    
    func fetchSchools() {
        SchoolAPI.shared.fetchSchools()
            .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { schools in
                self.schools = schools
                if let school = schools.first {
                    self.selectedSchool = school
                    print("selected", self.selectedSchool)
                }
            })
            .store(in: &cancellables)
    }
}

extension UserDefaults {
    func setSchool(_ school: School, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(school)
            self.set(data, forKey: key)
        } catch {
            print("Unable to encode School: \(error)")
        }
    }
    
    func getSchool(forKey key: String) -> School? {
        if let data = self.data(forKey: key) {
            do {
                let school = try JSONDecoder().decode(School.self, from: data)
                return school
            } catch {
                print("Unable to decode Schoo: \(error)")
            }
        }
        return nil
    }
}
