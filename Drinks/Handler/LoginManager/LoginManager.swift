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
        let params = [ "fb_id"  : self.me.socialID!]
        SwiftLoader.show(true)
        print(params)
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_CheckUserExisting, paramters: params) { (isSuccess, response, strError) in
                SwiftLoader.hide()
                    if isSuccess{
                        print(response)
                        if let userInfo = response as? Dictionary< String, Any>
                        {
                          if  let dictUser = userInfo["User"]  as? Dictionary< String, Any>
                          {
                            if dictUser.count > 0 {
                                
                                self.me.fullName = dictUser["full_name"] as! String
                                
                                let jobDict = dictUser["job"] as! Dictionary< String, Any>
                                let finalJob = jobDict["JobList"] as! Dictionary< String, Any>
                                
                                self.me.job = Job(jobInfo: finalJob)
                                self.me.ID =  dictUser["id"] as! String
                                //id = 598ad8c4a642be73658b4567
                                
//                                "full_name" = "Maninderjit Singh";
//                                id = 598ad8c4a642be73658b4567;
//                                job =         {
//                                    JobList =             {
//                                        "eng_name" = "English Job2";
//                                        id = 5982d7a16d349c79068b4567;
//                                        "jap_name" = "Japan Job2";
//                                    };
//                                };
                                
                                
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
        
        let parms = ["fb_id" : self.me.socialID , "job_id" : self.me.job.ID  , "full_name" : me.fullName , "dob" : me.DOB , "blood_type" : self.me.bloodGroup  , "marriage" : self.me.relationship , "tabaco" : me.tabaco , "school_career" : me.schoolCareer , "annual_income" : me.annualIncome ]
        
        
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_Register, paramters: parms, Images: image) { (success, response, strError) in
            if success{
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                    let dictUser = dictResponse["User"]  as? Dictionary<String ,Any>
                    if dictUser != nil
                    {
                        
                        self.me.fullName = dictUser?["full_name"] as! String
                        let jobDict = dictUser?["job"] as! Dictionary< String, Any>
                        let finalJob = jobDict["JobList"] as! Dictionary< String, Any>
                        
                        self.me.job = Job(jobInfo: finalJob)
                        self.me.ID =  dictUser?["id"] as! String
                 //      // let meUser = User(dict: dictUser)
                      //  self.me = meUser
                        handler(true , self.me, strError)
                    }
                }
                
            }else{
                
                handler(false , nil, strError)
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
