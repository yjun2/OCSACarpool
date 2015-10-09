//
//  CarpoolGroup.swift
//  OCSACarpool
//
//  Created by Yong Jun on 10/5/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import Foundation

public class CarpoolGroup {
    
    var groupName: String
    var creator: PFUser
    var members:[PFUser]
    
    init(groupName: String, creator: PFUser, members: [PFUser]) {
        self.groupName = groupName
        self.creator = creator
        self.members = members
    }
    
    convenience init(groupName: String) {
        self.init(groupName: groupName, creator: PFUser.currentUser()!, members: [PFUser.currentUser()!])
    }
    
    func saveToParse() {
        let group = PFObject(className: "Group")
        group.setObject(self.groupName, forKey: "groupName")
        group.setObject(self.creator, forKey: "creator")
        group.setObject(self.members, forKey: "members")
        
        group.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("saved successfully")
            } else {
                print("error \(error?.localizedDescription)")
            }
        }
    }
    
    // test retrieving
    class func retrieveGroup(groupName: String, completion: (group: CarpoolGroup?) -> Void) {
        
        let query = PFQuery(className: "Group")
        query.whereKey("groupName", equalTo: groupName)
        
        // Queries will not include related objects in the response by default. 
        // You can use includeKey: in your query to specify that user should be included:
        query.includeKey("creator")
        query.includeKey("members")

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print("error \(error?.localizedDescription)")
            } else {
                if objects?.count == 0 {
                    completion(group: nil)
                } else {
                    // there is always only one group
                    let object = objects?.first
                
                    let name = object!.valueForKey("groupName") as! String
                    let crt = object!.valueForKey("creator") as! PFUser
                    let members = object!.valueForKey("members") as! [PFUser]
                    let carpoolGroup = CarpoolGroup(groupName: name, creator: crt, members: members)
                    
                    completion(group: carpoolGroup)
                }
            }
        }
        
    }
    
    class func addUserToGroupMemberList(groupName: String, user: PFUser, completion: (success: Bool) -> Void) {
        let query = PFQuery(className: "Group")
        query.whereKey("groupName", equalTo: groupName)
        query.includeKey("members")
        
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let obj = object {
                var members = obj.valueForKey("members") as! [PFUser]
                members.append(user)
                
                obj.setObject(members, forKey: "members")
    
                obj.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                    if result {
                        print("members added for \(groupName)")
                        completion(success: true)
                    } else {
                        print("\(error?.localizedDescription)")
                        completion(success: false)
                    }
                })
            }
        }
    }
}