//
//  RequestBuilderProtocol.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

protocol RequestBuilderProtocol {
    var url: URLBuilderProtocol { get set }
    var httpMethod: HTTPMethod { get }
    var body: Encodable? { get set }
    var boundary: String? { get }
    var header: HeaderType { get }
    
    func getRequest() throws -> URLRequest
}

extension RequestBuilderProtocol {
    func getRequest() throws -> URLRequest {
        let url = try url.getURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.value

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
