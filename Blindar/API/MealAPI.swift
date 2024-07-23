//
//  MealAPI.swift
//  Blindar
//
//  Created by Suji Lee on 7/9/24.
//

import Combine
import Foundation

private let domain = Bundle.main.object(forInfoDictionaryKey: "DOMAIN") as? String ?? ""

class MealAPI {
    static let shared = MealAPI()
    
    func fetchMeals(schoolCode: Int, year: Int, month: String) -> AnyPublisher<MealResponse, Error> {
        print("params", schoolCode, year, month)
        var components = URLComponents(string: "https://\(domain)/meal")
        components?.queryItems = [
            URLQueryItem(name: "school_code", value: "\(schoolCode)"),
            URLQueryItem(name: "year", value: "\(year)"),
            URLQueryItem(name: "month", value: "\(month)")
        ]
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: MealResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch failed: \(error.localizedDescription)")
                case .finished:
                    print("Fetch finished successfully")
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
