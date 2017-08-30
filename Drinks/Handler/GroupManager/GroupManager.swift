//
//  GroupManager.swift
//  Drinks
//
//  Created by maninder on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupManager: NSObject {

    fileprivate var group : Group = Group()

    
    class var getGroup: Group {
        
        return GroupManager.sharedInstance.group
        
    }
    
    class func setGroup( group : Group)
    {
        
        GroupManager.sharedInstance.group = group
        
    }

    
    
    class var sharedInstance: GroupManager {
        struct Static {
            static let instance: GroupManager = GroupManager()
        }
        
        return Static.instance
    }
    
    

    
    
    func sendInterest(handler:@escaping CompletionHandler){
        
        var interestStatus = true
        
        if self.group.drinkedStatus == .Drinked{
            interestStatus = false
        }
        
        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID! ,"group_id" : self.group.groupID! , "drinked_status" : interestStatus]
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            if isSuccess
            {
                print(response)
                
            }else{
                
                
            }
        }
        
        
        
    }
    
}
