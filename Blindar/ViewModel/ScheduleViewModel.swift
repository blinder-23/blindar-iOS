//
//  ScheduleViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 8/6/24.
//

import Foundation
import Combine

class ScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    func fetcSchedules(schoolCode: Int, year: Int, month: String) -> AnyPublisher<[Schedule], Never> {
        return Future<[Schedule], Never> { promise in
            ScheduleAPI.shared.fetchSchedules(schoolCode: schoolCode, year: year, month: month)
                .receive(on: DispatchQueue.main) // 메인 스레드에서 값을 받도록 설정
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
                }, receiveValue: { scheduleResponse in
                    //디버깅
//                    print("학사 일정 반환값 : ", scheduleResponse)
                    self.schedules = scheduleResponse.response
                    promise(.success(self.schedules))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}
