//
//  WhaleAPI.swift
//  Whale
//
//  Created by fnord on 3/20/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Alamofire
import ObjectMapper
import KeychainSwift

let apiKey = "56beeef0c5e34b939e93ac369ff28438"

private protocol APIRequest {
    var endpoint: Whale {get}
    var baseURL: NSURL {get}
    var headers: [HTTPHeader] {get}
    var query: [String: Any] {get}
    var retType: Mappable.Type {get}
}

private protocol Endpoint {
    var path : String {get}
    var method: HTTPMethod {get}
}

public enum Whale {
    private var token: String? {
        return KeychainSwift().get("authToken")
    }
    
    case GetUsers
    case GetAnswers(perPage: Int, pageNum: Int)
    case GetQuestions(perPage: Int, pageNum: Int)
    case GetComments(answerId: Int, perPage: Int, pageNum: Int)
    case GetLikes(answerId: Int, perPage: Int, pageNum: Int)
    case LoginUser(username: String, password: String)
    case CreateUser(email: String, firstName: String, lastName: String, password: String, username: String, image: UIImage?)
    case CreateAnswer(questionId: String, video: String, thumbnail: UIImage)
    case CreateQuestion(recieverId: String, content: String)
}

extension Whale: Endpoint {
    fileprivate var path: String {
        switch self {
        case .GetAnswers:
            return "api/v1/answers"
        case .GetComments(let answerId):
            return "api/v1/answers/\(answerId)/comments"
        case .GetUsers, .CreateUser:
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
    
    fileprivate var method: HTTPMethod {
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

    fileprivate let endpoint: Whale
    
    fileprivate var baseURL: NSURL {
        return NSURL(string: "https://whale2-elixir.herokuapp.com/")!
    }
    
    fileprivate var headers: [HTTPHeader] {
        switch endpoint {
        case .GetAnswers,
             .GetComments,
             .GetLikes,
             .GetQuestions,
             .CreateAnswer,
             .CreateQuestion:
            return [.Authorization(KeychainSwift().get("authToken")! as String)]
        default:
            return []
        }
    }
    
    fileprivate var query: [String : Any] {
        switch endpoint {
        case .GetAnswers(let perPage, let pageNum),
             .GetComments(_, let perPage, let pageNum),
             .GetLikes(_, let perPage, let pageNum),
             .GetQuestions(let perPage, let pageNum):
            return ["per_page": perPage, "page": pageNum]
        case .LoginUser(let email, let password):
            return ["email": email, "password": password]
        case .CreateQuestion(let recieverId, let content):
            return ["receiver_id": recieverId, "content": content]
        case .CreateUser(let email, let firstName, let lastName, let password, let username, _):
            return ["email": email, "first_name": firstName, "last_name": lastName, "password": password, "username": username] //TODO: Add file
        case .CreateAnswer: //TODO: fix answer
            return [:]
        default:
            return [:]
        }
    }
    
    fileprivate var retType: Mappable.Type {
        switch endpoint {
        case .GetAnswers:
            return Answer.self
        case .GetComments:
            return Comment.self
        case .GetLikes:
            return Like.self
        case .GetQuestions:
            return Question.self
        case .GetUsers:
            return User.self
        case .LoginUser:
            return User.self
        case .CreateQuestion:
            return Question.self
        case .CreateUser:
            return User.self
        case .CreateAnswer: //TODO: fix answer
            return Answer.self
        }
    }
    
    private var url: URL {
        let fullPath = self.baseURL.appendingPathComponent(self.endpoint.path)!
        return fullPath
    }
    
    public init(endpoint: Whale) {
        self.endpoint = endpoint
    }
    
//    public func asURLRequest() throws -> URLRequest {
//        let url = self.url
//        
//        r
//    }
    
    public typealias Data = Mappable
    
    public func get(completionHandler: @escaping (Result<Mappable>) -> Void) {
        let head = self.headers.map {($0.key, $0.requestHeaderValue)}.reduce([String: String]()) { (acc, kv)in
            var ret = acc
            ret[kv.0] = kv.1
            return ret
        }
        
        Alamofire.request(self.url, method: self.endpoint.method, parameters: self.query, encoding: URLEncoding.default, headers: head).validate().responseString { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler(Result.Failure(error))
            case .success(let json):
                switch self.endpoint{
                case .LoginUser, .CreateUser:
                    guard let token = response.response?.allHeaderFields["Authorization"] as? String else{
                        print("There is no token wtf?")
                        break
                    }
                    
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: "authToken")
                default:
                    break
                }
                
                
                guard let obj = self.retType.init(JSONString: json) else {
                    print("something went wrong with optional chaining when returning the object")
                    break
                }
                
                completionHandler(Result.Success(obj))
            }
        }
    }
}
