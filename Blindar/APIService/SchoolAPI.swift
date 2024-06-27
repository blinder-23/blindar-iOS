//
//  School.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import Combine
import Foundation

private let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""

class SchoolAPI {
    static let shared = SchoolAPI()
    
    func fetchSchools() -> AnyPublisher<SchoolResponse, Error> {
        guard let url = URL(string: "https://\(baseURL)/school_list") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        print("request : ", request)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: SchoolResponse.self, decoder: JSONDecoder())
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

