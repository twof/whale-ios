//
//  ProfileTabViewController.swift
//  Whale
//
//  Created by fnord on 3/24/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileTabViewController: UIViewController {
    var user: UserViewModel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionService = WhaleService(endpoint: Whale.GetSession)
            
        sessionService.get { (result) in
            switch result{
            case .Failure(let error):
                print(error)
            case .Success(let user):
                self.user = UserViewModel(user: user as! User)
                
                self.user.getImage(completion: { (profileImage) in
                    self.profileImageView.image = profileImage
                })
                self.nameLabel.text = self.user.usernameText
                self.followingCountLabel.text = self.user.followingCountText
                self.followersCountLabel.text = self.user.followerCountText
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        KeychainSwift().delete("authToken")
        performSegue(withIdentifier: "logout", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
