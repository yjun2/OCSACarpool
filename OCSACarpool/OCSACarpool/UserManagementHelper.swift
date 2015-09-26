//
//  UserManagementHelper.swift
//  OCSACarpool
//
//  Created by Yong Jun on 9/25/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import Foundation
import UIKit

class UserManagementHelper {

    class func verifyEmailAddress(emailAddress: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailAddress)
    }
    
    class func displayAlertWithTitle(alertTitle: String, message msg: String) -> UIAlertController {
        let alertView = UIAlertController(title: alertTitle, message: msg, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return alertView
    }
    
    class func isEmailAddressVerified(email: String, completion: (result: Bool) -> Void) {
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let username = object.valueForKey("username") as! String
                    if username == email {
                        let emailVerified = object.valueForKey("emailVerified") as! Bool
                        completion(result: emailVerified)
                        break
                    }
                }
            }
        })
    }

    class func checkForEmptyTextFields(fields: [UITextField], completion: (result: Bool) -> Void) {
        var isEntered = true
        for field in fields {
            if field.text?.characters.count == 0 {
                isEntered = false
                break
            }
        }
        
        completion(result: isEntered)
    }
    
}