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
    
    func postUser(newUser: User) -> AnyPublisher<UserResponse, Error> {
        // 디버깅: 사용자 객체를 JSON 데이터로 변환
        do {
            let jsonData = try JSONEncoder().encode(newUser)
            // JSON 데이터 디코딩하여 콘솔에 출력
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                for (key, value) in json {
                    if let stringValue = value as? String {
                        print("\(key): \(stringValue) (String)")
                    } else {
                        print("\(key): \(value) (Not a String)")
                    }
                }
            }
            
            // JSON 데이터 문자열로 변환하여 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Data to send: \(jsonString)")
            }
        } catch {
            print("Failed to encode user or decode JSON: \(error.localizedDescription)")
        }
        
        let components = URLComponents(string: "https://\(domain)/user/update")
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(newUser)
            request.httpBody = jsonData
            
            // JSON 데이터 문자열로 변환하여 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Failed to encode user: \(error.localizedDescription)")
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
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("사용자 등록값 반환 failed: \(error.localizedDescription)")
                case .finished:
                    print("사용자 등록값 반환 finished successfully")
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

