//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 24.12.2023.
//

import Foundation

public class NetworkManager {
    private let session = URLSession(configuration: .default)
    
    func performRequest<ResponseType: NetworkResponse>(_ request: NetworkRequest<ResponseType>) async throws -> ResponseType {
        
        let (data, response) = try await session.data(for: request.getRequest())
        
        guard response.isSuccess else {
            throw NetError.httpError(statusCode: response.asHTTPURLRespose.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(ResponseType.self, from: data)
        } catch {
            throw NetError.decodingError(error)
        }
    }    
}
