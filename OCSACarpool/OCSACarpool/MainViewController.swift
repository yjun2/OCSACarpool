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

    @IBAction func createGroup(sender: UIButton) {
        
        let name = "Test Carpool Group"
        
        // check for duplicate group name
        GroupManagementHelper.isGroupAlreadyExist(name) { (result) -> Void in
            if result {  // group name already exists
                let alert = UserManagementHelper.displayAlertWithTitle("Error", message: "Group name '\(name)' already exists")
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let group = CarpoolGroup(groupName: name)
                group.saveToParse()
            }
        }
        
    }
    
    @IBAction func retrieveGroup(sender: UIButton) {
        // testing purpose
        CarpoolGroup.retrieveGroup("Test Carpool Group") { (group: CarpoolGroup?) -> Void in
            if let g = group {
                print("group name: \(g.groupName)")
                
                let val = g.creator.username!
                print("creator: \(val)")
                for member in g.members {
                    print("member: \(member.username!)")
                }
            } else {
                print("group not found")
            }
        }
        
    }
    
    
    @IBAction func invite(sender: UIButton) {
        // testing purpose
        let name = "Test Carpool Group"
        
        UserManagementHelper.retrieveUser("yongjun@gmail.com") { (result: PFUser?) -> Void in
            if let user = result {
                CarpoolGroup.addUserToGroupMemberList(name, user: user) { (success) -> Void in
                    if success {
                        print("updated successfully")
                    } else {
                        print("did not get updated")
                    }
                }
            }
        }
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
