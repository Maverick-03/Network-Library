//
//  NetworkServiceProtocol.swift
//  Paint
//
//  Created by Maverick on 03/03/26.
//

import Foundation

protocol NetworkServiceProtocol{
    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T
}

enum NetworkServiceError: Error {
    case failedResponse(_ data: Data, urlResponse: URLResponse)
}

final class NetworkService: NetworkServiceProtocol {
    let session: URLSession = .shared
    
    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
        do{
            let (data,urlResponse) = try await session.data(for: request)
            
            guard let urlResponse = urlResponse as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else{
                throw NetworkServiceError.failedResponse(data, urlResponse: urlResponse)
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw error
        }
    }
}
