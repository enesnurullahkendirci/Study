//
//  NetworkManager.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: BaseRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request.url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(T.ResponseType.self, from: data)
                completion(.success(response))
            } catch let decodingError as DecodingError {
                switch decodingError {
                case .typeMismatch(_, let c), .valueNotFound(_, let c), .keyNotFound(_, let c), .dataCorrupted(let c):
                    print(c.debugDescription)
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
