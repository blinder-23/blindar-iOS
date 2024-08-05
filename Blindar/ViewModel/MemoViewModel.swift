//
//  MemoViewModel.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import Foundation
import Combine

class MemoViewModel: ObservableObject {
    @Published var newMemoId: String?
    @Published var memos: [Memo] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    func fetchMemos(userId: String) {
        MemoAPI.shared.fetchMemos(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.memos = data.response ?? []
            })
            .store(in: &cancellables)
    }
    
    func postMemo(newMemo: Memo) -> AnyPublisher<String?, Never> {
        return Future<String?, Never> { promise in
            MemoAPI.shared.postMemo(newMemo: newMemo)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        promise(.success(nil))
                    case .finished:
                        break
                    }
                }, receiveValue: { data in
                    self.newMemoId = data.memoId ?? ""
                    promise(.success(self.newMemoId))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func editMemo(newMemo: Memo) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            MemoAPI.shared.postMemo(newMemo: newMemo)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        promise(.success(()))
                    case .finished:
                        break
                    }
                }, receiveValue: { data in
                    promise(.success(()))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func deleteMemo(memoId: String) {
        MemoAPI.shared.deleteMemo(memoId: memoId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] successMessage in
                self?.successMessage = successMessage
            })
            .store(in: &cancellables)
    }
}
