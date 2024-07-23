//
//  MealViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/9/24.
//

import Combine
import SwiftUI

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMeals: [Meal] = [] // 선택된 날짜에 해당하는 식단 정보
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMeals(schoolCode: Int, year: Int, month: String) {
        MealAPI.shared.fetchMeals(schoolCode: schoolCode, year: year, month: month)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { mealResponse in
                self.meals = mealResponse.response
                
            })
            .store(in: &cancellables)
    }
}
