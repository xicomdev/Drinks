//
//  LoginManager.swift
//  Kite Flight
//
//  Created by maninder on 5/16/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit

enum EntryType : String{
    case Manual = "Manual"
    case Facebook = "Facebook"
    case Google = "Google"
}


typealias CompletionResultHandler = (_ success: Bool, _ response: Any? , _ error : String?) -> Void


class LoginManager: NSObject {
   
    fileprivate var me: User! = User()
    
    class var getMe: User {
        
        return LoginManager.sharedInstance.me
    }
    
    class func setMe( user : User)
    {
         LoginManager.sharedInstance.me = user
    }
    
    override init() {
        super.init()
        let me = self.getMeArchiver()
        if (me == nil) {
            self.me = User()
        }else{
            self.me = me
        }
    }
    
    /**
     Returns the default singleton instance.
     */
    
    class var sharedInstance: LoginManager {
        struct Static {
            static let instance: LoginManager = LoginManager()
        }
        return Static.instance
    }
    
    
    //MARK:- Register API
    //MARK:-
    
     
    
    func checkUserExists(handler:@escaping CompletionHandler)
    {
        let params : [String : Any] = [ "fb_id"  : self.me.socialID!]
        SwiftLoader.show(true)
        
      print(params)
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_CheckUserExisting, paramters: params) { (isSuccess, response, strError) in
                SwiftLoader.hide()
                    if isSuccess
                    {
                        print(response)
                        if let userInfo = response as? Dictionary< String, Any>
                        {
                          if  let dictUser = userInfo["User"]  as? Dictionary< String, Any>
                          {
                            if dictUser.count > 0 {
                                
                                self.parseUserData(dictUser: dictUser)

                                handler(true, self.me, nil)
                            }else{
                                 handler(true, nil, nil)
                            }
                            
                          }else{
                            handler(true, nil, nil)
                         }
                        }
                    }else{
                        handler(isSuccess, nil, strError)
                 }
            }
    }
    
    
    
    func signUp(image : [MSImage] , handler:@escaping CompletionHandler )
    {
        
        
        let parms : [String : Any] = ["fb_id" : self.me.socialID! , "job_id" : self.me.job.ID  , "full_name" : me.fullName , "dob" : me.DOB , "blood_type" : self.me.bloodGroup  , "marriage" : self.me.relationship , "tabaco" : me.tabaco , "school_career" : me.schoolCareer , "annual_income" : me.annualIncome , "fb_image" : me.imageURL  , "gender" : self.me.myGender.rawValue]
        
        print(parms)
        SwiftLoader.show(true)
        
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_Register, paramters: parms, Images: image) { (success, response, strError) in
            SwiftLoader.hide()

            if success{
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                   if let dictUser = dictResponse["User"]  as? Dictionary<String ,Any>
                   {
                    
                    self.parseUserData(dictUser: dictUser)
                    handler(true , self.me, strError)

                    }
                    
                }
                
            }else
            {
                
                handler(false , nil, strError)
            }
        }
    }
    
    func updateUserProfile(image : [MSImage] ,UpdatedUser: User, handler:@escaping CompletionHandler )
    {
        let parms : [String : Any] = ["job_id" : UpdatedUser.job.ID  , "full_name" : UpdatedUser.fullName , "dob" : UpdatedUser.DOB , "blood_type" : UpdatedUser.bloodGroup  , "marriage" : UpdatedUser.relationship , "tabaco" : UpdatedUser.tabaco , "school_career" : UpdatedUser.schoolCareer , "annual_income" : UpdatedUser.annualIncome , "fb_image" : UpdatedUser.imageURL  , "gender" : UpdatedUser.myGender.rawValue]
        
        print(parms)
        SwiftLoader.show(true)
        
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_UpdateUserDetail, paramters: parms, Images: image) { (success, response, strError) in
            SwiftLoader.hide()
            
            if success{
                
                handler(true , nil, strError)
                
            }else
            {
                handler(false , nil, strError)
            }
        }
    }
    
    func updateNotifications (handler:@escaping CompletionHandler ) {
        SwiftLoader.show(true)
        let params = [
            "notification_receive_offer": Int(NSNumber(value:LoginManager.getMe.notificationSettings.newOffer)),
            "notification_when_matching": Int(NSNumber(value:LoginManager.getMe.notificationSettings.match)),
            "notification_message": Int(NSNumber(value:LoginManager.getMe.notificationSettings.message)),
            "notification_notice": Int(NSNumber(value:LoginManager.getMe.notificationSettings.notice))
        ]
        print(params)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_UpdateNotifications, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                handler(true, nil, nil)
            }else{
                handler(isSuccess, nil, strError)
            }
        }
    }
    
    func getUserDetail (handler:@escaping CompletionHandler ) {
        HTTPRequest.sharedInstance().getRequest(urlLink: API_GetUSerDetail, paramters: nil) { (isSuccess, response, strError) in
//        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetUSerDetail, paramters: nil) { (isSuccess, response, strError) in
            if isSuccess
            {
                print(response)
                if let userInfo = response as? Dictionary< String, Any>
                {
                    if  let dictUser = userInfo["User"]  as? Dictionary< String, Any>
                    {
                        if dictUser.count > 0 {
                            
                            self.parseDataFromProfile(dictUser: dictUser)
                            
                            handler(true, self.me, nil)
                        }else{
                            handler(true, nil, nil)
                        }
                        
                    }else{
                        handler(true, nil, nil)
                    }
                }
            }else{
                handler(isSuccess, nil, strError)
            }
        }
    }
    
    func parseDataFromProfile(dictUser: [String: Any]) {
        
        self.me.fullName = dictUser["full_name"] as! String
        self.me.ID =  dictUser["id"] as! String
        
        self.me.bloodGroup =  dictUser["blood_type"] as! String
        self.me.annualIncome =  dictUser["annual_income"] as! String
        self.me.DOB =  dictUser["dob"] as! String
        self.me.relationship =  dictUser["marriage"] as! String
        self.me.schoolCareer =  dictUser["school_career"] as! String
        self.me.socialID =  dictUser["fb_id"] as! String
        
        self.me.tabaco =  dictUser["tabaco"] as! String
        self.me.myCredits = "\(dictUser["balance"] as! Int)"
        self.me.membershipStatus = dictUser["membership_status"] as! String
        self.me.myCouponCode = dictUser["coupon_code"] as! String
        self.me.offersCount = "\(dictUser["offer_count"] as! Int)"
        if dictUser["image"] as? String != ""
        {
            self.me.imageURL = dictUser["image"] as! String
            
        }else if let fbImageURL = dictUser["fb_image"] as? String
        {
            self.me.imageURL = fbImageURL
        }
        self.me.notificationSettings = Notifications(notificationDict: dictUser)
        self.saveUserProfile()
    }
    
    func parseUserData(dictUser : [String : Any])
    {
        
        self.me.fullName = dictUser["full_name"] as! String
        let jobDict = dictUser["job"] as! Dictionary< String, Any>
        self.me.job = Job(jobInfo: jobDict)
        self.me.ID =  dictUser["id"] as! String
        self.me.sessionID =  dictUser["session_id"] as! String
        
        self.me.bloodGroup =  dictUser["blood_type"] as! String
        self.me.annualIncome =  dictUser["annual_income"] as! String
        self.me.DOB =  dictUser["dob"] as! String
        self.me.relationship =  dictUser["marriage"] as! String
        self.me.schoolCareer =  dictUser["school_career"] as! String
        self.me.socialID =  dictUser["fb_id"] as! String
        
        self.me.tabaco =  dictUser["tabaco"] as! String
        self.me.myCredits = "\(dictUser["balance"] as! Int)"
        self.me.membershipStatus = dictUser["membership_status"] as! String
        self.me.myCouponCode = dictUser["coupon_code"] as! String
        if dictUser["offer_count"] != nil {
            self.me.offersCount = "\(dictUser["offer_count"] as! Int)"
        }
        if dictUser["image"] as? String != ""
        {
            self.me.imageURL = dictUser["image"] as! String
            
        }else if let fbImageURL = dictUser["fb_image"] as? String
        {
            self.me.imageURL = fbImageURL
        }
        self.saveUserProfile()
    }
    
    func logOut(handler:@escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_LogOut, paramters: nil) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                FBSDKAccessToken.setCurrent(nil)
                handler(isSuccess, response, strError)
                
                //getOutOfApp()
            }else{
                handler(isSuccess, nil, strError)
            }
        }
    }
    
    //MARK:- User default functions
    //MARK:-
    
    func saveUserProfile() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.me)
        
        UserDefaults.standard.set(data, forKey: "Me")
        UserDefaults.standard.synchronize()
        
    }
    
    func removeUserProfile(){
        UserDefaults.standard.removeObject(forKey: "Me")
        UserDefaults.standard.synchronize()
        self.me = User()
    }
    
    func getMeArchiver() -> User? {
        if let data = UserDefaults.standard.object(forKey: "Me") as? Data {
            let me = NSKeyedUnarchiver.unarchiveObject(with: data)
            return me as? User
        }else{
            return nil
        }
    }
    
}
