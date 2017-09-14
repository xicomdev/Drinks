//
//  HTTPRequest.swift
//  Kite Flight
//
//  Created by maninder on 5/17/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit

typealias CompletionHandler = (_ success: Bool, _ response: Any? , _ error : String?) -> Void


class HTTPRequest: NSObject {

    
    class func sharedInstance() -> HTTPRequest {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let manager = HTTPRequest()
        }
        /** @return Returns the default singleton instance. */
        return Static.manager
    }

    

    
    func setHeader(_ manager: AFHTTPSessionManager)
    {
        manager.requestSerializer.setValue(timeStamp, forHTTPHeaderField: "timeStamp")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "user_id")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "session_id")
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            manager.requestSerializer.setValue(LoginManager.getMe.ID, forHTTPHeaderField: "user_id")
            manager.requestSerializer.setValue(LoginManager.getMe.sessionID, forHTTPHeaderField: "session_id")
        }
        
        
        if userDefaults.value(forKey: "DeviceToken") as? String != nil{
            manager.requestSerializer.setValue(userDefaults.value(forKey: "DeviceToken") as? String, forHTTPHeaderField: "token")
        }else{
            manager.requestSerializer.setValue("000000000000000", forHTTPHeaderField: "token")
        }
        
        manager.requestSerializer.setValue( deviceUniqueIdentifier() , forHTTPHeaderField: "device_id")
        //device_id
    }
    
 
    //MARK:- Creation of Requests
    //MARK:-
    
    func getRequest( urlLink: String, paramters : Dictionary<String ,Any>?, handler:@escaping CompletionHandler)
    {
        let strFinalURL: String = Constants.webURL.URLBaseAddress + urlLink

        let manager = AFHTTPSessionManager()
        self.setHeader(manager)
        manager.get(strFinalURL, parameters: paramters, success: { (taskSuccess, responseSuccess) in
            
            guard  let dictResponse = responseSuccess as? Dictionary<String, Any>
            else{
                                return
                }
          
            if let status = dictResponse["status"] as? Bool
            {
                if status == true
                {
                    handler(true, dictResponse["data"]  , nil)
                }else {
                    self.checkSessionExpired(dictResponse: dictResponse)
                    handler(false, nil, dictResponse["message"] as? String)
                }
            }
            
        
            
        }) { (task, error) in
            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            print("content received : \(str)")
               handler(false, nil, error.localizedDescription)
        }
    }
    
    
    
    
    
func postRequest( urlLink: String, paramters : Dictionary<String ,Any>?, handler:@escaping CompletionHandler)
    {
        let strFinalURL: String = Constants.webURL.URLBaseAddress + urlLink
      //  print(strFinalURL)
        
        let manager = AFHTTPSessionManager()
        
        self.setHeader(manager)

          manager.post(strFinalURL, parameters: paramters, success: { (taskSuccess, responseSuccess) in
            
            guard  let dictResponse = responseSuccess as? Dictionary<String, Any>
            else{
                return
            }
            
            print(dictResponse)
          if let status = dictResponse["status"] as? Bool{
                if status == true
                 {
                    handler(true, dictResponse["data"]  , nil)
                }else {
                    
                    self.checkSessionExpired(dictResponse: dictResponse)
                    handler(false, nil, dictResponse["message"] as? String)
                }
            }
            
        }) { (task, error) in
            
            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            print("content received : \(str)")
            
            handler(false, nil, error.localizedDescription)
        }
        
    }
    
    
    
    
    func postMulipartRequest( urlLink: String, paramters: Dictionary<String ,Any>?,  Images : [MSImage] , handler:@escaping CompletionHandler){
        
        let strFinalURL: String = Constants.webURL.URLBaseAddress + urlLink
        let manager = AFHTTPSessionManager()
        self.setHeader(manager)

        print(strFinalURL)
        manager.post(strFinalURL, parameters: paramters, constructingBodyWith: { (formData) in
           
            if Images.count > 0 {
                let image = Images[0]
             formData.appendPart(withFileData: UIImageJPEGRepresentation((image.file)! , 1)!, name: image.name , fileName: image.filename, mimeType: image.mimeType)
            }
        }, success: { (task, responseValue) in
            
            guard  let dictResponse = responseValue as? Dictionary<String, Any>
                else{
                    return
            }
            
            print(dictResponse)

            if let status = dictResponse["status"] as? Bool{
                if status == true
                {
                    handler(true, dictResponse["data"]  , nil)
                }else {
                    
                    
                    self.checkSessionExpired(dictResponse: dictResponse)
                    handler(false, nil, dictResponse["message"] as? String)
                }
            }

        }, failure: { (task, error) in
            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            print("content received : \(str)")
            handler(false, nil, error.localizedDescription)

        })
    }
    
    
    func checkSessionExpired(dictResponse : Dictionary<String, Any>)
    {
        
        if let statusCode = dictResponse["status_code"] as? NSNumber
        {
            if statusCode == 203
            {
                getOutOfApp()
                return
            }
        }
        
    }
    
    
    
   }



