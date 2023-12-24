//
//  NetworkRequest.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 24.12.2023.
//

import Foundation

public struct NetworkRequest<ResponseType: NetworkResponse> {
    let method: HTTPMethod
    let url: URLBuilderProtocol
    var header: HeaderType
    var boundary: String?
    var body: Data?
}

extension NetworkRequest {
    func getRequest() throws -> URLRequest {
        let url = try url.getURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.value

        switch header {
        case .standard:
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        case .multipart:
            guard let boundary else { break }
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        if let body {
            do {
                let data = try body.encodeData()
                urlRequest.httpBody = data
            } catch {
                throw NetworkError.RequestConstruction.addingBodyFailed
            }
        }
        return urlRequest
    }
}
