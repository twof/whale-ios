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
            
            if let qList = qList {
                for i in 1..<qList.count{
                    currentQuestion.nextQuestion = qList[i]
                    currentQuestion = currentQuestion.nextQuestion!
                }
            }
        }
    }
}


/*
 data": [
 {
 "sender": {
 "username": "jessica_garnet",
 "last_name": "Garnet",
 "image_url": "https://placehold.it/100x100",
 "id": 6,
 "first_name": "Jessica",
 "email": "jessica@mail.com"
 },
 "receiver": {
 "username": "Brody",
 "last_name": "Stafford",
 "image_url": "https://whale-bucket.s3.amazonaws.com/users/avatars/janna_stafford_lashawnda.koester@for-president.com/55_thumb.jpg?v=63657283258",
 "id": 24,
 "first_name": "Janna",
 "email": "lashawnda.koester@for-president.com"
 },
 "id": 19,
 "content": "What books have changed your life the most?"
 }
 */
