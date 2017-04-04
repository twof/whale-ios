//
//  UserViewModel.swift
//  Whale
//
//  Created by fnord on 4/3/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserViewModel {
    var user: User!
    
    init(user: User) {
        self.user = user
    }
    
    var usernameText: String {
        return self.user.username
    }
    
    var followerCountText: String {
        return "Followers: \(self.user.followerCount ?? 0)"
    }
    
    var followingCountText: String {
        return "Following: \(self.user.followingCount ?? 0)"
    }
    
    func getImage(completion: @escaping (UIImage) -> ()) {
        Alamofire.request(user.imageURL).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}
