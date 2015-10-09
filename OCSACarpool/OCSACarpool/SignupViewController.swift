//
//  ViewController.swift
//  OCSACarpool
//
//  Created by Yong Jun on 9/21/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var firstnameTxtField: UITextField!
    @IBOutlet weak var lastnameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    var keyboardHandler: IQKeyboardReturnKeyHandler!
    
    lazy var fieldsArray: [UITextField] = {
        return [self.emailTxtField, self.firstnameTxtField, self.lastnameTxtField, self.passwordTxtField, self.confirmPasswordTxtField]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler = IQKeyboardReturnKeyHandler(controller: self)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardHandler = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func close_signup(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signup(sender: UIButton) {
        var goodToGo = true
        
        UserManagementHelper.checkForEmptyTextFields(fieldsArray) { (result) -> Void in
            if result == false {
                let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "All fields are required")
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // check email address
                if UserManagementHelper.verifyEmailAddress(self.emailTxtField.text!) == false {
                    let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Email address is not valid.  Re-enter your email address")
                    self.presentViewController(alert, animated: true, completion: nil)
                    goodToGo = false
                }
                
                // check if passwords match
                if self.verifyPassword(self.passwordTxtField?.text, confirmPassword: self.confirmPasswordTxtField?.text) == false {
                    goodToGo = false
                    let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Passwords do not match.  Re-enter your passwords")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                // Sign up the user
                if goodToGo {
                    let user = PFUser()
                    user.username = self.emailTxtField.text
                    user.email = self.emailTxtField.text
                    user.password = self.passwordTxtField.text
                    user.setObject(self.firstnameTxtField.text!, forKey: "firstName")
                    user.setObject(self.lastnameTxtField.text!, forKey: "lastName")
                    
                    user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            // prevent auto-login.  must verify email before it can be logged in
                            PFUser.logOut()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            let alert = UserManagementHelper.displayAlertWithTitle("Error", message: error!.localizedDescription)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: private method
    private func verifyPassword(password: String?, confirmPassword password2: String?) -> Bool {
        var verified = false
        
        if let p1 = password, p2 = password2 {
            if p1 == p2 {
                verified = true
            }
        }
        
        return verified
    }
    
}

