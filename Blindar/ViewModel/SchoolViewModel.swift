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
            })
            .store(in: &cancellables)
    }
}
