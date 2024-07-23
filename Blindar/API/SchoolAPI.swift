//
//  School.swift
//  Blindar
//
//  Created by Suji Lee on 6/27/24.
//

import Combine
import Foundation

private let domain = Bundle.main.object(forInfoDictionaryKey: "DOMAIN") as? String ?? ""

class SchoolAPI {
    static let shared = SchoolAPI()
    
    func fetchSchools() -> AnyPublisher<[School], Error> {
        guard let url = URL(string: "https://\(domain)/school_list") else {
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
            .decode(type: SchoolResponse.self, decoder: JSONDecoder())
            .map { schoolResponse in
                schoolResponse.data.map { School(schoolName: $0.schoolName, schoolCode: $0.schoolCode) }
            }
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
