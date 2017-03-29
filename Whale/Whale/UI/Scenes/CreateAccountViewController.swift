//
//  CreateAccountViewController.swift
//  Whale
//
//  Created by fnord on 3/27/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let email = validate(text: emailTextField.text) else{
            self.errorLabel.text = "Enter an email"
            return
        }
        
        guard let username = validate(text: usernameTextField.text) else {
            self.errorLabel.text = "Enter a username"
            return
        }
        
        guard let firstName = validate(text: firstNameTextField.text) else {
            self.errorLabel.text = "Enter your first name"
            return
        }
        
        guard let lastName = validate(text: lastNameTextField.text) else {
            self.errorLabel.text = "Enter your last name"
            return
        }
        
        guard let password = validate(text: passwordTextField.text) else {
            self.errorLabel.text = "Enter a password"
            return
        }
        
        guard let confirmedPassword = validate(text: confirmPasswordTextField.text) else {
            self.errorLabel.text = "Confirm your password"
            return
        }
        
        if password == confirmedPassword {
            let createAccountService = WhaleService(endpoint: Whale.CreateUser(email: email, firstName: firstName, lastName: lastName, password: password, username: username, image: nil))
            
            createAccountService.get(completionHandler: { (response) in
                switch response {
                case .Failure(let error):
                    print(error)
                    self.errorLabel.text = "User could not be created. Maybe you have an account already?"
                case .Success:
                    self.performSegue(withIdentifier: "toMainFromAccountCreation", sender: self)
                }
            })
        }else{
            self.errorLabel.text = "Passwords don't match."
        }
    }
    
    func validate(text: String?) -> String? {
        if let text = text {
            if text.characters.count >= 4 {
                return text
            }else{
                return nil
            }
        }else{
            return nil
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
