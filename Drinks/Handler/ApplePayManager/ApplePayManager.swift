//
//  ApplePayManager.swift
//  Drinks
//
//  Created by maninder on 9/28/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class ApplePayManager: NSObject,PKPaymentAuthorizationViewControllerDelegate
{
    
    var request : PKPaymentRequest!
    
   // var controller : UIViewController? = nil
    var plan_id = String()
    
    override init()
    {
        self.request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayDrinksMerchantID
        request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa ,  PKPaymentNetwork.discover,  PKPaymentNetwork.JCB , PKPaymentNetwork.masterCard]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
    }
    
    class var sharedInstance: ApplePayManager {
        struct Static {
            static let instance: ApplePayManager = ApplePayManager()
        }
        return Static.instance
    }
    
    func paymentVCForPremiumPlan(controller : UIViewController, plan:PremiumPlan)
    {
        let objItem = PKPaymentSummaryItem(label: plan.engName , amount: NSDecimalNumber(value: plan.amount))
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: plan.amount))
        plan_id = plan.planID
        request.paymentSummaryItems = [objItem, total]
        let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
        objApplePay.delegate = self
        controller.present(objApplePay, animated: true, completion: nil)
    }
    
    func paymentVCForTicket(controller : UIViewController, ticket:Ticket)
    {
        let objItem = PKPaymentSummaryItem(label: ticket.engName , amount: NSDecimalNumber(value: ticket.amount))
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: ticket.amount))
        request.paymentSummaryItems = [objItem, total]
        let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
        objApplePay.delegate = self
        controller.present(objApplePay, animated: true, completion: nil)
    }
    
    //MARK:- Payment Authorization Delegates
    //MARK:-
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        Stripe.setDefaultPublishableKey("pk_test_FW8MfVIULqvEd7iDhkDnbah7")
        
        STPAPIClient.shared().createToken(with: payment) {
            (token, error) -> Void in
            
            if (error != nil) {
                completion(PKPaymentAuthorizationStatus.failure)
                return
            }
            
            let params = [
                "stripeToken":(token?.tokenId)!,
                "plan_id":self.plan_id
            ]
            HTTPRequest.sharedInstance().postRequest(urlLink: API_BuySelectedPlan, paramters: params) { (isSuccess, response, strError) in
                if isSuccess
                {
                    completion(PKPaymentAuthorizationStatus.success)
                }else{
                    completion(PKPaymentAuthorizationStatus.failure)
                }
            }
        }
    }

}
