//
//  UserAPI.swift
//  Blindar
//
//  Created by Suji Lee on 7/19/24.
//

import Foundation
import Combine

private let domain = Bundle.main.object(forInfoDictionaryKey: "DOMAIN") as? String ?? ""

class UserAPI {
    static let shared = UserAPI()
    
    func postMemo(newUser: User) -> AnyPublisher<User, Error> {
        let components = URLComponents(string: "https://\(domain)/user/update")
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(newUser)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                switch httpResponse.statusCode {
                case 200:
                    print("사용자 등록 상태코드 200")
                default:
                    print("사용자 등록 상태코드: \(httpResponse.statusCode)")
                }
                return data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("사용자 등록 failed: \(error.localizedDescription)")
                case .finished:
                    print("사용자 등록 finished successfully")
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
