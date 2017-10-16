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
    
    convenience init(notificationDict : Any)
    {
        newOffer = notificationDict["notification_receive_offer"] as! Bool
        match = notificationDict["notification_when_matching"] as! Bool
        message = notificationDict["notification_message"] as! Bool
        notice = notificationDict["notification_notice"] as! Bool

    }
    
    
}

