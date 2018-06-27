//
//  ChatManager.swift
//  Drinks
//
//  Created by maninder on 9/7/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ChatManager: NSObject {
    
    
    fileprivate var chatThread : ChatThread = ChatThread()
    
    
    class var getGroup: ChatThread {
        return ChatManager.sharedInstance.chatThread
        
    }
    
    class func setGroup( chatThread : ChatThread)
    {
        ChatManager.sharedInstance.chatThread = chatThread
    }
    
    
    
    class var sharedInstance: ChatManager {
        struct Static {
            static let instance: ChatManager = ChatManager()
        }
        return Static.instance
    }


    
    
  class  func getChatThreads(handler:@escaping CompletionHandler)
    {
     
       // SwiftLoader.show(true)
        var params : [String : Any] = [String : Any]()
        
        if appDelegate().appLocation != nil
        {
            params["current_latitude"] = (appDelegate().appLocation)!.latitude
            params["current_longitude"] = (appDelegate().appLocation)!.longtitude
        }
        print(params)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetChatThreads, paramters: params) { (isSuccess, response, strError) in
        //    SwiftLoader.hide()
            if isSuccess
            {
                var arrayChats = [ChatThread]()
                
                if let arrayResponse = response as? [Any]
                {
                    for item in arrayResponse
                    {
                        let thread = ChatThread(groupThread: item)
                        arrayChats.append(thread)
                    }
                }
             handler(true, arrayChats, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
        
    }
    
    class  func getChatThreadsHistory(handler:@escaping CompletionHandler)
    {
        
        // SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetThreadsHistory, paramters: nil) { (isSuccess, response, strError) in
            //    SwiftLoader.hide()
            if isSuccess
            {
                var arrayChats = [ChatThread]()
                
                if let arrayResponse = response as? [Any]
                {
                    for item in arrayResponse
                    {
                        let thread = ChatThread(groupThread: item)
                        arrayChats.append(thread)
                    }
                }
                handler(true, arrayChats, nil)
            }else{
                handler(false, nil, strError!)
            }
        }
        
    }
    

}
