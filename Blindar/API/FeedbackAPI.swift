//
//  FeedbackAPI.swift
//  Blindar
//
//  Created by Suji Lee on 7/16/24.
//

import Foundation
import Combine

private let domain = Bundle.main.object(forInfoDictionaryKey: "DOMAIN") as? String ?? ""

class FeedbackAPI {
    static let shared = FeedbackAPI()
        
    func postFeedback(newFeedback: Feedback) -> AnyPublisher<String, Error> {
        let components = URLComponents(string: "https://\(domain)/feedback")
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(newFeedback)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                // 성공한 경우, 성공 메시지 반환
                return "Feedback successfully posted"
            }
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("post failed: \(error.localizedDescription)")
                case .finished:
                    print("post finished successfully")
                }
            })
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return NSError(domain: "Network Error", code: URLError.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
                    case .badServerResponse:
                        return NSError(domain: "Server Error", code: URLError.badServerResponse.rawValue, userInfo: [NSLocalizedDescriptionKey: "Bad server response"])
                    default:
                        return error
                    }
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
