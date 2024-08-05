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
    @Published var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    func fetchMeals(schoolCode: Int, year: Int, month: String) -> AnyPublisher<[Meal], Never> {
        return Future<[Meal], Never> { promise in
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
                    promise(.success(self.meals))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}
