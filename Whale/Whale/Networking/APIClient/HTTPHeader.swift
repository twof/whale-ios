//
//  HTTPHeader.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//
public enum HTTPHeader {
    
    case ContentDisposition(String)
    case Accept([String])
    case ContentType(String)
    case Authorization(String)
    case ContentLength(String)
    case Custom(String, String)
    
    
    var key: String {
        switch self {
        case .ContentDisposition:
            return "Content-Disposition"
        case .Accept:
            return "Accept"
        case .ContentType:
            return "Content-Type"
        case .Authorization:
            return "Authorization"
        case .ContentLength:
            return "Content-Length"
        case .Custom(let key, _):
            return key
        }
    }
    
    var requestHeaderValue: String {
        switch self {
        case .ContentDisposition(let disposition):
            return disposition
        case .Accept(let types):
            return types.joined(separator: ", ")
        case .ContentType(let type):
            return type
        case .Authorization(let token):
            return token
        case .ContentLength(let length):
            return length
        case .Custom(_, let value):
            return value
        }
    }
}
