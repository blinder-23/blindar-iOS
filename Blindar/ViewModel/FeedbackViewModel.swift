//
//  FeedbackViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import Foundation
import Combine

class FeedbackViewModel: ObservableObject {
    @Published var successMessage: String?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func postFeedback(newFeedback: Feedback) {
        FeedbackAPI.shared.postFeedback(newFeedback: newFeedback)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] successMessage in
                self?.successMessage = successMessage
                // 디버깅
                print("Feedback Post success: ", successMessage)
            })
            .store(in: &cancellables)
    }
}
