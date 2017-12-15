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
        self.permissions = ["public_profile","email","user_friends","user_birthday"]
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
        FBSDKProfile.setCurrent(nil)
     FBSDKGraphRequest(graphPath: "me/permissions", parameters: nil, httpMethod: "DELETE").start { (connection , result, error) -> Void in
        
        }
        
        
        let storage:HTTPCookieStorage =  HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        defaults.synchronize()
    }
    
    
    private func profile(callBack:@escaping (Bool,AnyObject?,String?)->()) {
    
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "first_name,last_name,picture.type(normal),email,birthday,gender"])
        graphRequest.start(completionHandler: { ( connection , result, error) -> Void in
            if (error != nil) {
                 self.logout()
                callBack(false,nil, error?.localizedDescription)
                return
            }
            
            if  let dictResult = result as? Dictionary<String , Any> {
                
                print(dictResult)
            }
            
            callBack(true,result as AnyObject?,nil)
            
        })
        
    }
    
    func getFriendList() {
        
        let params : [String : Any] = ["fields": "id, name, email, picture"]
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                print(result as! NSDictionary)
                if let userData = result as? NSDictionary {
                    let aryData = (userData)["data"] as! NSArray
                    let aryFriends = NSMutableArray()
                    for obj in aryData {
                        let dict = obj as! NSDictionary
                        let newDict = [
                            "name": dict["name"] as! String,
                            "id": dict["id"] as! String,
                            "image" : dict.value(forKeyPath: "picture.data.url") as! String
                        ]
                        aryFriends.add(newDict)
                    }
                    if let objectData = try? JSONSerialization.data(withJSONObject: aryFriends, options: JSONSerialization.WritingOptions(rawValue: 0)) {
                        let objectString = String(data: objectData, encoding: .utf8)

                        let param = ["friends_list":objectString!]
                    
                        HTTPRequest.sharedInstance().postRequest(urlLink: API_UpdateFbFriends, paramters: param, handler: { (flag, response, errorStr) in
                            print(flag)
                        })
                    
                    }
                }
            } else {
                
                print("Error Getting Friends \(error)");
            }
            
        })
        
        connection.start()
        
    }
  
    
    
    
    
    
    func currentTokenString() -> String {
        return FBSDKAccessToken.current().tokenString;
    }
    
    func currentUserProfile( viewController : UIViewController , callBack:@escaping (Bool,AnyObject?,String?)->()) {

            self.login(viewController: viewController, callBack:  { (isSuccess:Bool, result:AnyObject?, error:String?) -> () in
                if isSuccess {
                    
                    self.profile(callBack: callBack)
                }else{
                      callBack(false,nil,error)
                }
            })
    }
    
    
    func login(viewController: UIViewController, callBack:@escaping (Bool,AnyObject?,String?)->()) {
        self.loginManager.logOut()

        self.loginManager.logIn(withReadPermissions: self.permissions, from: viewController) { (result, error) in
            
            if error != nil {
                
                callBack(false,nil,error?.localizedDescription)
                return
            }
            
            if (result?.isCancelled)!{
                callBack(false,nil,NSLocalizedString("User cancelled the action.", comment: ""))
                return
            }
            
            callBack(true,result,nil)
        }

    }


}
