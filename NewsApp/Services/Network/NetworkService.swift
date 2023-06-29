//
//  NetworkService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import Combine
import UIKit

protocol NetworkServiceProtocol {
    var session: URLSession { get }
}

extension NetworkServiceProtocol {
    var session: URLSession {
        return URLSession.shared
    }
    
    func performDataTask<T: Decodable>(
        with request: URLRequest,
        decoder: JSONDecoder = .init(),
        queue: DispatchQueue = .main,
        retries: Int = 0
    ) -> AnyPublisher<HTTPResponse<T>, Error> {
        session.dataTaskPublisher(for: request)
            .retry(retries)
            .tryMap { result -> HTTPResponse<T> in
                guard result.response.isSuccess else {
                    throw try decoder.decode(HTTPErrorResponse.self, from: result.data)
                }
                
                let data = try decoder.decode(T.self, from: result.data)
                return HTTPResponse(value: data, response: result.response)
            }
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
}
