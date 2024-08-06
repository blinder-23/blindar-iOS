//
//  ScheduleAPI.swift
//  Blindar
//
//  Created by Suji Lee on 8/6/24.
//

import Foundation
import Combine

private let domain = Bundle.main.object(forInfoDictionaryKey: "DOMAIN") as? String ?? ""

class ScheduleAPI {
    static let shared = ScheduleAPI()
    
    func fetchSchedules(schoolCode: Int, year: Int, month: String) -> AnyPublisher<ScheduleResponse, Error> {
        var components = URLComponents(string: "https://\(domain)/schedule")
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
            .decode(type: ScheduleResponse.self, decoder: JSONDecoder())
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
