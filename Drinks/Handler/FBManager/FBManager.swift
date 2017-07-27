//
//  FBManager.swift
//  Who's In
//
//  Created by Maninderjit Singh on 04/07/16.
//  Copyright © 2016 XICOM. All rights reserved.
//

import UIKit

class FBManager: NSObject  {

    
    var shareCallBack:((Bool)->Void)? = nil
    var inviteCallBack:((Bool)->Void)? = nil


   // @property (nonatomic, copy) FBShareCallBack shareCallBack;
    var loginManager:FBSDKLoginManager!
    var permissions = [String]()
    var userID:String? = ""
    
    override init() {
        
       // super.init()
        self.permissions = ["public_profile","email","user_friends"]
        self.loginManager = FBSDKLoginManager()
        
    }
    
    

    class var sharedInstance: FBManager {
        struct Static {
            static let instance: FBManager = FBManager()
        }
        return Static.instance
    }
    
    
    
     
    
    // MARK: - logout FB
    
    func logout(){
        
        self.loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
     FBSDKGraphRequest(graphPath: "me/permissions", parameters: nil, httpMethod: "DELETE").start { (connection , result, error) -> Void in
        
        }
        
        
        let storage:HTTPCookieStorage =  HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        defaults.synchronize()
    }
    
    
    private func profile(callBack:@escaping (Bool,AnyObject?,NSError?)->()) {
    
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "first_name,last_name,picture.type(normal),email,birthday,gender"])
        graphRequest.start(completionHandler: { ( connection , result, error) -> Void in
            if (error != nil) {
                 self.logout()
                callBack(false,nil,error as NSError?)
                return
            }
            
            if  let dictResult = result as? Dictionary<String , Any> {
                self.userID = dictResult["id"] as? String
            }
            callBack(true,result as AnyObject?,nil)
            
        })
        
    }
    
    func currentTokenString() -> String {
        return FBSDKAccessToken.current().tokenString;
    }
    
    func currentUserProfile( viewController : UIViewController , callBack:@escaping (Bool,AnyObject?,NSError?)->()) {

            self.login(viewController: viewController, callBack:  { (isSuccess:Bool, result:AnyObject?, error:NSError?) -> () in
                if isSuccess {
                    self.profile(callBack: callBack)
                }else{
                      callBack(false,nil,nil)
                }
            })
    }
    
    
    func login(viewController: UIViewController, callBack:@escaping (Bool,AnyObject?,NSError?)->()) {
        self.loginManager.logIn(withReadPermissions: self.permissions, from: viewController) { (result, error) in
            
            if error != nil {
                
                callBack(false,nil,error as NSError?)
                return
            }
            
            if (result?.isCancelled)!{
                callBack(false,nil,nil)
                return
            }
            
            callBack(true,result,nil)
        }

    }


}
