//
//  Comment.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import ObjectMapper

public class Comment: Mappable {
    var id: Int!
    var content: String!
    var commenter: User!
    var answerId: Int!
    var nextComment: Comment?
    private var cList: [Comment]?
    
    required public init?(map: Map) {}
    
    
    public func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        commenter <- map["commenter"]
        answerId <- map["answer_id"]
        
        if map["data"].isKeyPresent {
            cList <- map["data"]
            
            id <- map["data.0.id"]
            content <- map["data.0.content"]
            commenter <- map["data.0.commenter"]
            answerId <- map["data.0.answer_id"]
            
            var currentComment = self
            
            if let cList = cList, cList.count > 0 {
                for i in 1..<cList.count {
                    currentComment.nextComment = cList[i]
                    currentComment = currentComment.nextComment!
                }
            }
        }
    }
}
