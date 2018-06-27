//
//  GroupManager.swift
//  Drinks
//
//  Created by maninder on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Firebase

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
    
//    enum DrinkStatus : String
//    {
//        case Drinked = "drinked"
//        case NotDrinked = "undrinked"
//        case Waiting = "waiting"
//        case Confirmed = "confirmed"
//    }
    
    func sendOrRemoveInterest(handler:@escaping CompletionHandler){
        
        Analytics.logEvent("Make_interest_to_group", parameters: nil)
        var interestStatus  : String = ""
        if self.group.drinkedStatus == .NotDrinked
        {
            interestStatus = "drinked"
        }else{
            interestStatus = "undrinked"
        }
        
        
        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID! ,"group_id" : self.group.groupID! , "drinked_status" : interestStatus , "owner_user_id" : self.group.ownerID!]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
               if self.group.drinkedStatus == .NotDrinked
                {
                       self.group.drinkedStatus = .Drinked
                }else
                {
                  //  self.group.drinkedStatus = .Confirmed
                }
                handler(true, self.group, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
    }
    
    func acceptInterest(handler:@escaping CompletionHandler)
    {
        Analytics.logEvent("Interest_back_to_confirm_match", parameters: nil)

        print( (self.group.groupRequest?.groupID)! )
         print( (self.group.groupRequest?.groupOwner.ID)!  )
        let params : [String : Any] = ["user_id" : (self.group.groupRequest?.groupOwner.ID)!   ,"group_id" : (self.group.groupRequest?.groupID)!
 , "drinked_status" : "drinked" , "owner_user_id" : self.group.ownerID!]
        

        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
           
            if isSuccess
            {
                self.group.drinkedStatus = .Matched
                
                //self.group.drinkedStatus = .Confirmed
                handler(true, self.group, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
    }
    
    func acceptInterestRequested(requestedGroup: Group, handler:@escaping CompletionHandler)
    {
        Analytics.logEvent("Interest_back_to_confirm_match", parameters: nil)

        print( (requestedGroup.groupRequest?.groupID)! )
        print( (requestedGroup.groupRequest?.groupOwner.ID)!  )
        self.group = requestedGroup
        let params : [String : Any] = ["user_id" : (requestedGroup.groupRequest?.groupOwner.ID)!   ,"group_id" : (requestedGroup.groupRequest?.groupID)!
            , "drinked_status" : "confirmed" , "owner_user_id" : requestedGroup.ownerID!]
        
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            
            if isSuccess
            {
                self.group.drinkedStatus = .Matched
                //self.group.drinkedStatus = .Confirmed
                handler(true, self.group, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
    }
    
    func removeInterest(handler:@escaping CompletionHandler)
    {
        
        print( (self.group.groupRequest?.groupID)! )
        let params : [String : Any] = ["user_id" : (self.group.groupRequest?.groupOwner.ID)! ,"group_id" : (self.group.groupRequest?.groupID)! , "drinked_status" : "undrinked" , "owner_user_id" : self.group.ownerID!]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            
           if isSuccess
            {
//                
//                if self.group.drinkedStatus == .Confirmed
//                {
//                    self.group.drinkedStatus = .NotDrinked
//                }else
//                {
//                    self.group.drinkedStatus = .Confirmed
//                }
                handler(true, self.group, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
    }

    
    
    
    


    
    
//    func sendInterest(handler:@escaping CompletionHandler){
//        
//        var interestStatus = true
//        if self.group.drinkedStatus == .Drinked{
//            interestStatus = false
//        }
//       
//        
//        let params : [String : Any] = ["user_id" : LoginManager.getMe.ID! ,"group_id" : self.group.groupID! , "drinked_status" : interestStatus , "owner_user_id" : self.group.ownerID!]
//        SwiftLoader.show(true)
//        HTTPRequest.sharedInstance().postRequest(urlLink: API_Interest, paramters: params) { (isSuccess, response, strError) in
//            SwiftLoader.hide()
//
//            if isSuccess
//            {
//                if self.group.drinkedStatus == .Drinked{
//                    self.group.drinkedStatus = .NotDrinked
//                }else{
//                    self.group.drinkedStatus = .Drinked
//                }
//                handler(true, self.group, nil)
//            }else{
//              handler(false, nil, strError!)
//            }
//        }
//        
//    }
//    
//    
    func getBeOfferedGroup(handler:@escaping CompletionHandler)
    {
        
        var params : [String : Any] = [
            "user_id" : LoginManager.getMe.ID!,
        ]
        if appDelegate().appLocation?.latitude != nil {
            params.updateValue(appDelegate().appLocation!.latitude, forKey: "current_latitude")
            params.updateValue(appDelegate().appLocation!.longtitude, forKey: "current_longitude")
        }
        
        
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_ReceivedOffer  , paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var arrayList = [Group]()

                if let arryResponse = response as? [Dictionary<String ,Any>]
                {
                    for item in arryResponse{
                        let  groupNew = Group(groupBoth: item)
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
        let params : [String : Any] = [
            "user_id" : LoginManager.getMe.ID!,
            "current_latitude" : appDelegate().appLocation!.latitude,
            "current_longitude" : appDelegate().appLocation!.longtitude
        ]
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
                        let  groupNew = Group(groupBoth: item)
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
