//
//  Like.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import ObjectMapper

public class Like: Mappable {
    var userId: Int!
    var user: User!
    var id: Int!
    var answerId: Int!
    var nextLike: Like?
    private var lList: [Like]?
    
    required public init?(map: Map) {}
    
    
    public func mapping(map: Map) {
        userId <- map["user_id"]
        user <- map["user"]
        id <- map["id"]
        answerId <- map["answer_id"]
        
        if map["data"].isKeyPresent {
            lList <- map["data"]
            
            userId <- map["data.0.user_id"]
            user <- map["data.0.user"]
            id <- map["data.0.id"]
            answerId <- map["data.0.answer_id"]
            
            var currentLike = self
            
            if let lList = lList, lList.count > 0 {
                for i in 1..<lList.count {
                    currentLike.nextLike = lList[i]
                    currentLike = currentLike.nextLike!
                }
            }
        }
    }
}
