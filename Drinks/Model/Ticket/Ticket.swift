//
//  Ticket.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit

class Ticket: NSObject
{
    
    var engName : String!
    var japName : String!
    var amount : Double!
    var ticketID : String!
    var discount : Double!
    var tickets : Int!
    
    
    override init()
    {

    }

    convenience  init(dict : Any)
    {
        self.init()
        
        guard let dictPlan = dict as? Dictionary<String, Any> else {
            return
        }
        
        engName = dictPlan["eng_name"] as! String
        japName = dictPlan["jap_name"] as! String
        ticketID = dictPlan["id"] as! String
        amount = Double(dictPlan["amount"] as! String)
        tickets = Int(dictPlan["ticket"] as! String)
        
        if (dictPlan["discount"] as? String) != nil {
            discount = Double(dictPlan["discount"] as! String)
        }else {
            discount = dictPlan["discount"] as! Double
            
        }
        
    }
    
    class func getTickets(handler:@escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetSubscriptionPlan, paramters: nil) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var tickets = [Ticket]()
                if let response = response as? [String: Any]
                {
                    if let ticketsResponse = response["tickets"] as? [Any]
                    {
                        for item in ticketsResponse
                        {
                            let ticket = Ticket(dict: item)
                            tickets.append(ticket)
                        }
                    }
                }
                handler(isSuccess, tickets , nil)
            }else{
                handler(isSuccess, nil , strError!)
            }
        }
    }
}
