//
//  ChatThread.swift
//  Drinks
//
//  Created by maninder on 9/7/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ChatThread: NSObject {
    var ID : String!
    var group : Group!
    var lastMessage : Message? = nil
    var threadMember : User = User()

    var messages : [Message] = [Message]()
    
    
    override init()
    {
        
        
        
    }
    
//    convenience init(groupThread : Any)
//    {
//        self.init()
//        guard let dictLocal = groupThread as? Dictionary<String, Any> else {
//            return
//        }
//        print(dictLocal)
//
//       // id = 59b0dc4486d89efd1e8b4567;
//
//        self.ID =  dictLocal["id"] as! String
//        self.threadMember = User(messageDict: dictLocal["second_member"]as Any)
//         self.group  = Group(chatGroup: dictLocal["Group"] as Any)
//        if let dictLastMessage = dictLocal["last_message"] as? Dictionary<String, Any>
//        {
//            if dictLastMessage.count > 0 {
//                self.lastMessage = Message(messageDict: dictLocal["last_message"] as Any)
//            }
//        }
//    }
    
    convenience init(groupThread : Any)
    {
        self.init()
        guard let dictLocal = groupThread as? Dictionary<String, Any> else {
            return
        }
        print(dictLocal)

        // id = 59b0dc4486d89efd1e8b4567;

        self.ID =  dictLocal["id"] as! String
        self.threadMember = User(messageDict: dictLocal["second_member"]as Any)
        self.group  = Group(chatGroup: dictLocal["Group"] as Any)
        if let dictLastMessage = dictLocal["last_message"] as? Dictionary<String, Any>
        {
            if dictLastMessage.count > 0 {
                self.lastMessage = Message(messageDictFromGroup: dictLocal)
            }
        }
    }
    
    
    convenience init(dictChatPush : Any)
    {
        self.init()
        guard let dictLocal = dictChatPush as? Dictionary<String, Any> else {
            return
        }
        
        // id = 59b0dc4486d89efd1e8b4567;
        
        self.ID =  dictLocal["id"] as! String
        self.threadMember = User(messageDict: dictLocal["sender_info"]as Any)
        self.group  = Group(chatGroup: dictLocal["group_info"] as Any)
        
    }

    
    
    
    func getAllMessages(handler : @escaping CompletionHandler)
    {
        let params : [String : Any] = ["thread_id" : self.ID  ]
      //  SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetThreadMessages, paramters: params) { (isSuccess, response, strError) in
          //  SwiftLoader.hide()
            if isSuccess
            {
                
                
                if let arrayMessage = response as? [Any]
                {
                    self.messages.removeAll()
                    for item in arrayMessage
                    {
                        let message = Message(messageDict: item)
                        self.messages.append(message)
                    }
                    handler(true , self, nil)
                }
            }else{
                
                handler(false , nil, strError)
            }
        }

        
    }
    
    
//    func createSelfMessage(strMessage : String)
//    {
//        var message = Message(selfDict: )
//        message.date = setMessageDate()
//        message.senderUser = LoginManager.getMe
//        message.message = strMessage
//        
//        
//    }
    
    
    func sendMessage( message : String , handler : @escaping CompletionHandler )
    {
        
        let params : [String : Any] = ["thread_id" : self.ID  , "receiver_id" : threadMember.ID , "message" : message  ]
        
      //  SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_SendChatMessage, paramters: params) { (isSuccess, response, strError) in
         //   SwiftLoader.hide()
            if isSuccess
            {
                
                
                if let message = response as? [String: Any]
                {
                    
                    let myMessage = Message(selfDict: message)
                    
                    handler(true , myMessage, nil)

                    
                }
            }else{
                
                handler(false , nil, strError)
            }
        }
    }
    
}
