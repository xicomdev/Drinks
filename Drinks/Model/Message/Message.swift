//
//  Message.swift
//  Drinks
//
//  Created by maninder on 9/7/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit


enum MessageStatus : String
{
    case Unread = "0" //As per Backend
    case Read = "1"
}


class Message: NSObject {
    var date : String!
    var message : String!
    var senderID : String!
    var threadID : String!
    var senderUser : User!

    
    override init()
    {
        
    }
    
    
    convenience init(messageDict : Any)
    {
        self.init()
        
        guard let dictMessage = messageDict as? Dictionary<String, Any> else {
            return
        }
        

       // self.date = dictMessage["datetime"] as! String
        self.message = dictMessage["message"] as! String
        self.threadID = dictMessage["thread_id"] as! String
         self.senderUser = User(messageDict: dictMessage["sender"]as Any)
          self.senderID = dictMessage["sender_id"] as! String
    }
    
    convenience init(selfDict : Any)
    {
        self.init()
        
        guard let dictMessage = selfDict as? Dictionary<String, Any> else {
            return
        }
        
       // self.date = dictMessage["datetime"] as! String
        self.message = dictMessage["message"] as! String
        self.threadID = dictMessage["thread_id"] as! String
        self.senderID = dictMessage["sender_id"] as! String
        self.senderUser = LoginManager.getMe

    }
}


    

