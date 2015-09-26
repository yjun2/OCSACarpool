//
//  LoginViewController.swift
//  OCSACarpool
//
//  Created by Yong Jun on 9/23/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!

    var keyboardHandler: IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler = IQKeyboardReturnKeyHandler(controller: self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardHandler = nil
    }
    
    @IBAction func login(sender: UIButton) {
        var goodToGo = true

        // check the email address format
        if UserManagementHelper.verifyEmailAddress(emailTxtField.text!) == false {
            goodToGo = false
            let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Email address format is not valid.  Re-enter your email address")
            presentViewController(alert, animated: true, completion: nil)
        }
        
        // next check if the email address has been verified
        UserManagementHelper.isEmailAddressVerified(emailTxtField.text!) { (result) -> Void in
            if result == false {
                goodToGo = false
                let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Email address has not been verified.  Check your email and verify your email address")
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                if goodToGo {
                    PFUser.logInWithUsernameInBackground(self.emailTxtField.text!, password: self.passwordTxtField.text!, block: {
                        (user: PFUser?, error: NSError?) -> Void in
                        if error == nil {
                            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! MainViewController
                            self.presentViewController(mainViewController, animated: true, completion: nil)
                        } else {
                            let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Login failed.  Check your email address or password")
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }

    }


}
