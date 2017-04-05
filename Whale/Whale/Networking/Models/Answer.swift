//
//  Answer.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import ObjectMapper

public class Answer: Mappable {
    var question: Question!
    var videoURL: URL!
    var thumbnailURL: URL!
    var likesCount: Int?
    var commentCount: Int?
    var id: Int!
    var nextAnswer: Answer?
    private var aList: [Answer]?
    
    required public init?(map: Map) {}
    
    
    public func mapping(map: Map) {
        videoURL <- (map["video_url"], URLTransform())
        thumbnailURL <- (map["thumbnail_url"], URLTransform())
        question <- map["question"]
        likesCount <- map["likes_count"]
        commentCount <- map["commnent_count"]
        id <- map["id"]
        
        if map["data"].isKeyPresent {
            aList <- map["data"]
            
            videoURL <- (map["data.0.video_url"], URLTransform())
            thumbnailURL <- (map["data.0.thumbnail_url"], URLTransform())
            question <- map["data.0.question"]
            likesCount <- map["data.0.likes_count"]
            commentCount <- map["data.0.commnent_count"]
            id <- map["data.0.id"]
            
            var currentAnswer = self
            
            if let aList = aList, aList.count > 0 {
                for i in 1..<aList.count {
                    currentAnswer.nextAnswer = aList[i]
                    currentAnswer = currentAnswer.nextAnswer!
                }
            }
        }
    }
}
