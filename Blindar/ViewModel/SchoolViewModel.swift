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
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSchools() {
        SchoolAPI.shared.fetchSchools()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.schools = response.data
                //디버깅
                print("학교 목록 조회 응답 데이터 : ", response)
            })
            .store(in: &cancellables)
    }
}

