//
//  PremiumPlan.swift
//  Drinks
//
//  Created by maninder on 9/28/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PremiumPlan: NSObject
{
    
    var engName : String!
    var japName : String!
    var amount : Double!
    var planID : String!
    var planDescription : String!

    var discount : Double!

//    amount = "3000.01";
//    description = "#trending1";
//    discount = "200.01";
//    "eng_name" = "6 month";
//    id = 59cb4b143b2efd835a4f410f;
//    "jap_name" = "6 \U6708";
//    type = "membership_plan";

    
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
        planID = dictPlan["id"] as! String
        amount = dictPlan["amount"] as! Double
        planDescription = dictPlan["description"] as! String
        discount = dictPlan["discount"] as! Double


        
       // amount = Decimal(string: decimal)
        
    }
    
    class func getPremiumPlans(handler:@escaping CompletionHandler)
    {
       HTTPRequest.sharedInstance().postRequest(urlLink: API_GetSubscriptionPlan, paramters: nil) { (isSuccess, response, strError) in
               if isSuccess
               {
                    var plans = [PremiumPlan]()
                if let response = response as? [String: Any]
                    {
                        if let plansResponse = response["membership_plans"] as? [Any]
                        {
                            for item in plansResponse
                            {
                                let plan = PremiumPlan(dict: item)
                                plans.append(plan)
                            }
                        }
                    }
                handler(isSuccess, plans , nil)
               }else{
                handler(isSuccess, nil , strError!)
            }
        }
     }
}
