//
//  Question.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import ObjectMapper

public class Question: Mappable {
    var sender: User!
    var receiver: User!
    var id: Int!
    var content: String!
    var nextQuestion: Question?
    private var qList: [Question]?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        sender <- map["sender"]
        receiver <- map["receiver"]
        id <- map["id"]
        content <- map["content"]
        
        if map["data"].isKeyPresent {
            qList <- map["data"]
            
            sender <- map["data.0.sender"]
            receiver <- map["data.0.receiver"]
            id <- map["data.0.id"]
            content <- map["data.0.content"]
            
            var currentQuestion = self
            
            if let qList = qList, qList.count > 0 {
                for i in 1..<qList.count {
                    currentQuestion.nextQuestion = qList[i]
                    currentQuestion = currentQuestion.nextQuestion!
                }
            }
        }
    }
}
