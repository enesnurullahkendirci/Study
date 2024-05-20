//
//  MockNetworkManager.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation
@testable import EnesKendirciCaseStudy

class MockNetworkManager: NetworkManagerProtocol {
    var jsonFileName: String?

    func fetch<T: BaseRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        guard let fileName = jsonFileName else {
            completion(.failure(NetworkError.noFileName))
            return
        }

        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(T.ResponseType.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.fileNotFound))
        }
    }

    enum NetworkError: Error {
        case noFileName
        case fileNotFound
    }
}
