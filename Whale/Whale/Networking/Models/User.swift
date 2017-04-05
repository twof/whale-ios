//
//  User.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable {
    var email: String!
    var username: String!
    var firstName: String!
    var lastName: String!
    var followerCount: Int?
    var followingCount: Int?
    var id: Int!
    var imageURL: URL!
    var nextUser: User?
    private var uList: [User]?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        email <- map["email"]
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        followerCount <- map["follower_count"]
        followingCount <- map["following_count"]
        id <- map["id"]
        imageURL <- (map["image_url"], URLTransform())
        
        if map["data"].isKeyPresent {
            uList <- map["data"]
            
            email <- map["data.0.email"]
            username <- map["data.0.username"]
            firstName <- map["data.0.first_name"]
            lastName <- map["data.0.last_name"]
            followerCount <- map["data.0.follower_count"]
            followingCount <- map["data.0.following_count"]
            id <- map["data.0.id"]
            imageURL <- (map["data.0.image_url"], URLTransform())
            
            var currentUser = self
            
            if let uList = uList{
                for i in 1..<uList.count{
                    currentUser.nextUser = uList[i]
                    currentUser = currentUser.nextUser!
                }
            }
        }
    }
}
