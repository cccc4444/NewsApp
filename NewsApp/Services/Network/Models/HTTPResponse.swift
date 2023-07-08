//
//  HTTPResponse.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

struct HTTPResponse<T: Decodable> {
    let value: T
    let response: URLResponse
}

struct HTTPErrorResponse: Decodable, Error {
    let fault: Fault
}

struct Fault: Decodable {
    let faultString: String
    let detail: Detail
    
    enum CodingKeys: String, CodingKey {
        case faultString = "faultstring"
        case detail
    }
}

struct Detail: Decodable {
    let errorCode: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
    }
}
