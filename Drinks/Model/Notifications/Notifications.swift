//
//  Notifications.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/16/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class Notifications: NSObject {
    
    var newOffer = Bool()
    var match = Bool()
    var message = Bool()
    var notice = Bool()
    
    override init()
    {
        
        
    }
    
    convenience init(notificationDict : [String: Any])
    {
        self.init()
        self.newOffer = notificationDict["notification_receive_offer"] as! Bool
        self.match = notificationDict["notification_when_matching"] as! Bool
        self.message = notificationDict["notification_message"] as! Bool
        self.notice = notificationDict["notification_notice"] as! Bool
    }
    
    
    
}

