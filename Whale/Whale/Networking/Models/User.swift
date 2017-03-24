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
    }
}
