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
    var ticket_id = String()
    var parentVC = UIViewController()
    var status = Bool()
    
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
        var objItem = PKPaymentSummaryItem()
        if Locale.preferredLanguages[0].contains("en") {
            objItem = PKPaymentSummaryItem(label: plan.engName , amount: NSDecimalNumber(value: plan.amount))
        }else {
            objItem = PKPaymentSummaryItem(label: plan.japName , amount: NSDecimalNumber(value: plan.amount))
        }
        let total = PKPaymentSummaryItem(label: NSLocalizedString("Total", comment: ""), amount: NSDecimalNumber(value: plan.amount))
        plan_id = plan.planID
        ticket_id = ""
        request.paymentSummaryItems = [objItem, total]
        let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
        objApplePay.delegate = self
        parentVC = controller
        
        if PKPaymentAuthorizationViewController.canMakePayments() {
            controller.present(objApplePay, animated: true, completion: nil)
        }

    }
    
    func paymentVCForTicket(controller : UIViewController, ticket:Ticket)
    {
        var objItem = PKPaymentSummaryItem()
        if Locale.preferredLanguages[0].contains("en") {
            objItem = PKPaymentSummaryItem(label: ticket.engName , amount: NSDecimalNumber(value: ticket.amount))
        }else {
            objItem = PKPaymentSummaryItem(label: ticket.japName , amount: NSDecimalNumber(value: ticket.amount))
        }
        let total = PKPaymentSummaryItem(label: NSLocalizedString("Total", comment: ""), amount: NSDecimalNumber(value: ticket.amount))
        plan_id = ""
        ticket_id = ticket.ticketID

        request.paymentSummaryItems = [objItem, total]
        let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
        objApplePay.delegate = self
        parentVC = controller

        if PKPaymentAuthorizationViewController.canMakePayments() {
            controller.present(objApplePay, animated: true, completion: nil)
        }
    }
    
    //MARK:- Payment Authorization Delegates
    //MARK:-
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: {
            if self.status{
                self.parentVC.navigationController!.popViewController(animated: true)
            }
        })
        
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        Stripe.setDefaultPublishableKey("pk_test_FW8MfVIULqvEd7iDhkDnbah7")
        
        STPAPIClient.shared().createToken(with: payment) {
            (token, error) -> Void in
            
            if (error != nil) {
                completion(PKPaymentAuthorizationStatus.failure)
                return
            }
            var params : Dictionary<String ,Any>?
            if self.plan_id != "" {
                params = [
                    "stripeToken":(token?.tokenId)!,
                    "plan_id":self.plan_id
                ]
            }else {
                params = [
                    "stripeToken":(token?.tokenId)!,
                    "ticket_id":self.ticket_id
                ]
            }
            
            HTTPRequest.sharedInstance().postRequest(urlLink: API_BuySelectedPlan, paramters: params) { (isSuccess, response, strError) in
                if isSuccess
                {
                    completion(PKPaymentAuthorizationStatus.success)
                    self.status = true
                }else{
                    completion(PKPaymentAuthorizationStatus.failure)
                    self.status = false
                }
            }
        }
    }

}
