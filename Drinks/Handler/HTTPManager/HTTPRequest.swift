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

    
    

//    func createParamters(dict : Dictionary<String ,Any>?) -> Dictionary<String ,Any>
//    {
//        var params = Dictionary<String ,Any>()
//       // params[APIKey] = Constants.webURL.API_KEY
//      //  params["device_type"] = DeviceType
//       // params["device_token"] = deviceToken()
//     //   params["language"] = languageSelected()
//
//        // guard let dict = paramters
//        // else { /* Handle nil case */ return }
//        
////        if dict != nil{
////            params =  params.merged(with: dict!)
////        }
//
//        return params
//    }
//    
    
    
    func setHeader(_ manager: AFHTTPSessionManager)
    {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue(timeStamp, forHTTPHeaderField: "timeStamp")
        //manager.requestSerializer.setValue("1", forHTTPHeaderField: "DeviceType")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "user_id")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "session_id")
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            manager.requestSerializer.setValue(LoginManager.getMe.ID, forHTTPHeaderField: "user_id")
            manager.requestSerializer.setValue(LoginManager.getMe.sessionID, forHTTPHeaderField: "session_id")
        }
    }

    
    //MARK:- Creation of Requests
    //MARK:-
    
    
    
    func getRequest( urlLink: String, paramters : Dictionary<String ,Any>?, handler:@escaping CompletionHandler)
    {
        let strFinalURL: String = Constants.webURL.URLBaseAddress + urlLink

    //    let dictParams = self.createParamters(dict: paramters)
        let manager = AFHTTPSessionManager()
     //   manager.requestSerializer = AFJSONRequestSerializer()
        self.setHeader(manager)
        manager.get(strFinalURL, parameters: paramters, success: { (taskSuccess, responseSuccess) in
            
            guard  let dictResponse = responseSuccess as? Dictionary<String, Any>
                            else{
                                return
                    }
            if let status = dictResponse["status"] as? Bool{
                if status == true
                {
                    handler(true, dictResponse["data"]  , nil)
                }else {
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
        
      //  manager.requestSerializer = AFJSONRequestSerializer()
        
       manager.requestSerializer.setValue(timeStamp, forHTTPHeaderField: "timeStamp")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "user_id")
      //  manager.requestSerializer.setValue("reteryr", forHTTPHeaderField: "token")
        manager.requestSerializer.setValue("", forHTTPHeaderField: "session_id")

        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            manager.requestSerializer.setValue(LoginManager.getMe.ID, forHTTPHeaderField: "user_id")
            manager.requestSerializer.setValue(LoginManager.getMe.sessionID, forHTTPHeaderField: "session_id")
        }

        print(paramters)
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
        if urlLink == API_UpdateProfile {
            self.setHeader(manager)
        }

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
    
    
    
    
    
    
    
    
    
    
   }



