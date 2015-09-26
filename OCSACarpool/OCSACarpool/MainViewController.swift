//
//  MainViewController.swift
//  OCSACarpool
//
//  Created by Yong Jun on 9/23/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil {
            let logInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            presentViewController(logInViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        
        let logInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        presentViewController(logInViewController, animated: true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
