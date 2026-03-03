//
//  NetworkServiceProtocol.swift
//  Paint
//
//  Created by Maverick on 03/03/26.
//

import Foundation

public protocol NetworkServiceProtocol{
    func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T
}

public enum NetworkServiceError: Error {
    case failedResponse(_ data: Data, urlResponse: URLResponse)
}

public final class NetworkService: NetworkServiceProtocol {
    let session: URLSession = .shared
    
    public init(){}
    
    public func request<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
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
