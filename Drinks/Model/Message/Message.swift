//
//  Message.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation

class Message: NSObject {
    var msgId : String = ""
    var msgContent : String = ""
    var senderId: String = String()
    var recieverId: String = String()
    var timestamp:String = ""
    
    override init() {
        
    }
    
    convenience init(_ sender_id: String) {
        self.init()

        self.msgContent = "Helloooo"
        self.msgId = "2"
        self.senderId = sender_id
        self.timestamp = "\(Date().timeIntervalSince1970)"
        self.recieverId = "2"
    }
    
        
    
}
