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
       
        
        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID! ,"group_id" : self.group.groupID! , "drinked_status" : interestStatus , "owner_user_id" : self.group.ownerID!]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()

            if isSuccess
            {
                if self.group.drinkedStatus == .Drinked{
                    self.group.drinkedStatus = .NotDrinked
                }else{
                    self.group.drinkedStatus = .Drinked
                }
                handler(true, self.group, nil)
            }else{
              handler(false, nil, strError!)
            }
        }
        
    }
    
    
    func getBeOfferedGroup(handler:@escaping CompletionHandler)
    {
        
        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID!]
        
        print(params)
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_ReceivedOffer  , paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var arrayList = [Group]()
                print(response)

                if let arryResponse = response as? [Dictionary<String ,Any>]
                {
                    for item in arryResponse{
                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayList.append(groupNew)
                    }
                }
                handler(true , arrayList, strError)
            }else{
                handler(false , nil, strError)
            }
        }

    }
    
    func getSentOfferedGroup(handler:@escaping CompletionHandler)
    {
        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID!]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_SentOffer  , paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var arrayList = [Group]()
                if let arryResponse = response as? [Dictionary<String ,Any>]
                {
                    
                    print(arryResponse)
                    for item in arryResponse
                    {
                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayList.append(groupNew)
                   }
                }
                handler(true , arrayList, strError)
            }else{
                handler(false , nil, strError)
            }
        }
    }
    
}
