//
//  WhaleAPI.swift
//  Whale
//
//  Created by fnord on 3/20/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

let apiKey = "56beeef0c5e34b939e93ac369ff28438"

enum Result<T> {
    case Success(T)
    case Failure(Error)
}

protocol Gettable {
    associatedtype Data
    
    func get(completionHandler: @escaping (Result<Data>) -> Void)
}

public protocol Endpoint {
    var path : String {get}
    var method: HTTPMethod {get}
}

private protocol APIRequest {
    var endpoint: Whale {get}
    var baseURL: NSURL {get}
    var headers: [HTTPHeader] {get}
    var query: [String: Any] {get}
}

public protocol APIResponse {
    var httpResponse: HTTPURLResponse? {get}
    var data: NSData? {get}
    var error: Error? {get}
    var originalRequest: NSURLRequest? {get}
    var contentType: String? {get}
}

public enum Whale {
    case GetUsers
    case GetAnswers(perPage: Int, pageNum: Int, authToken: String)
    case GetQuestions(perPage: Int, pageNum: Int, authToken: String)
    case GetComments(answerId: Int, perPage: Int, pageNum: Int, authToken: String)
    case GetLikes(answerId: Int, perPage: Int, pageNum: Int, authToken: String)
    case LoginUser(username: String, password: String)
    case CreateUser(email: String, firstName: String, lastName: String, password: String, username: String, image: UIImage?)
    case CreateAnswer(questionId: String, video: String, thumbnail: UIImage, authToken: String)
    case CreateQuestion(recieverId: String, content: String, authToken: String)
}

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
    
    func setRequestHeader(request: NSMutableURLRequest) {
        request.setValue(requestHeaderValue, forHTTPHeaderField: key)
    }
}

extension Whale: Endpoint {
    public var path: String {
        switch self {
        case .GetAnswers:
            return "api/v1/answers"
        case .GetComments(let answerId):
            return "api/v1/answers/\(answerId)/comments"
        case .GetUsers,.CreateUser:
            return "api/v1/users"
        case .GetQuestions, .CreateQuestion:
            return "api/v1/questions"
        case .GetLikes(let answerId):
            return "api/v1/answers/\(answerId)/likes"
        case .LoginUser:
            return "api/v1/sessions"
        case .CreateAnswer(let answerId):
            return "api/v1/questions/\(answerId)/answers"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .GetAnswers,
             .GetComments,
             .GetUsers,
             .GetQuestions,
             .GetLikes:
            return .get
        case .LoginUser,
             .CreateAnswer,
             .CreateQuestion,
             .CreateUser:
            return .post
        }
    }
}

public struct WhaleService: APIRequest, Gettable {
    typealias Data = Mappable

    fileprivate let endpoint: Whale
    
    fileprivate var baseURL: NSURL {
        return NSURL(string: "https://whale2-elixir.herokuapp.com/")!
    }
    
    fileprivate var headers: [HTTPHeader] {
        switch endpoint {
        case .GetAnswers(_, _, let authToken),
             .GetComments(_, _, _, let authToken),
             .GetLikes(_, _, _, let authToken),
             .GetQuestions(_, _, let authToken),
             .CreateAnswer(_, _, _, let authToken),
             .CreateQuestion(_, _, let authToken):
            return [.Authorization(authToken)]
        default:
            return []
        }
    }
    
    fileprivate var query: [String : Any] {
        switch endpoint {
        case .GetAnswers(let perPage, let pageNum, _),
             .GetComments(_, let perPage, let pageNum, _),
             .GetLikes(_, let perPage, let pageNum, _),
             .GetQuestions(let perPage, let pageNum, _):
            return ["per_page": perPage, "page": pageNum]
        case .LoginUser(let username, let password):
            return ["username": username, "password": password]
        case .CreateQuestion(let recieverId, let content, _):
            return ["receiver_id": recieverId, "content": content]
        case .CreateUser(let email, let firstName, let lastName, let password, let username, _):
            return ["email": email, "first_name": firstName, "last_name": lastName, "password": password, "username": username] //TODO: Add file
        case .CreateAnswer: //TODO: fix answer
            return [:]
        default:
            return [:]
        }
    }
    
    private var url: URL {
        let fullPath = self.baseURL.appendingPathComponent(self.endpoint.path)!
        return fullPath
    }
    
    public init(endpoint: Whale) {
        self.endpoint = endpoint
    }
    
    internal func get(completionHandler: @escaping (Result<Mappable>) -> Void) {
        let head = self.headers.map {($0.key, $0.requestHeaderValue)}.reduce([String: String]()) { (acc, kv)in
            var ret = acc
            ret[kv.0] = kv.1
            return ret
        }
        
        Alamofire.request(self.url, method: self.endpoint.method, parameters: self.query, encoding: URLEncoding.default, headers: head).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                completionHandler(Result.Failure(error))
            case .success(let json):
                print(json)
                //completionHandler(Result.Success(User(JSONString: json)))
            }
        }
    }
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let percentEscapedValue = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}
