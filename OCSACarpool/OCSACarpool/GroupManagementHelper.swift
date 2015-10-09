//
//  GroupManagementHelper.swift
//  OCSACarpool
//
//  Created by Yong Jun on 10/6/15.
//  Copyright © 2015 Yong Jun. All rights reserved.
//

import Foundation

class GroupManagementHelper {
    
    class func isGroupAlreadyExist(groupName: String, completion: (result: Bool) -> Void) {
        let query = PFQuery(className: "Group")
        query.whereKey("groupName", equalTo: groupName)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if objects?.count == 0 {
                completion(result: false)
            } else {
                completion(result: true)
            }
        }
    }
}