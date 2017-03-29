//
//  LoginViewController.swift
//  Whale
//
//  Created by fnord on 3/22/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        let loginService = WhaleService(endpoint: Whale.LoginUser(username: email, password: password))
        
        loginService.get {(result) in
            switch result{
            case .Failure(let error):
                print(error)
                self.errorLabel.text = "Incorrect username or password"
            case .Success(let user):
                print(user)
                self.performSegue(withIdentifier: "toMainFromLogin", sender: self)
            }
        }
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
