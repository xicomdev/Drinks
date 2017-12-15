//
//  CouponVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/1/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class CouponVC: UIViewController {

    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnUseCode: SetCornerButton!
    @IBOutlet weak var btnShareCoupon: SetCornerButton!
    @IBOutlet weak var txtFldCode: UITextField!
    @IBOutlet weak var lblMyCode: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblMyCode.text = LoginManager.getMe.myCouponCode
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareCodeAction(_ sender: AnyObject) {
        
        let text = NSLocalizedString("Use my referal code and get free tickets.\nReferal code:", comment: "") + "\(lblMyCode.text!)" + "\n" + NSLocalizedString("If you enter this introduction code on the DRINKS application, you can get a ticket for free.", comment: "") + "\n" + "https://itunes.apple.com/" + NSLocalizedString("\n~ What is DRINKS ~\nIt is an application that you can match with groups you want to drink together tonight with tonight.", comment: "")
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTermsAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnUseCodeAction(_ sender: AnyObject) {
        if txtFldCode.text!.isStringEmpty() == true{
            showAlert(title: "Drinks", message: NSLocalizedString("Please enter coupon code.", comment: ""), controller: self)
        }else if txtFldCode.text! == lblMyCode.text! {
            showAlert(title: "Drinks", message: NSLocalizedString("You can not use your own coupon", comment: ""), controller: self)
        } else {
            SwiftLoader.show(true)

            let params = [
                "coupon_code":txtFldCode.text!
            ]
            HTTPRequest.sharedInstance().postRequest(urlLink: API_RedeemCoupon, paramters: params) { (isSuccess, response, strError) in
                 SwiftLoader.hide()
                if isSuccess
                {
                    self.txtFldCode.text = ""
                    let gotTicketsVc = mainStoryBoard.instantiateViewController(withIdentifier: "GotCouponTicketVC") as! GotCouponTicketVC
                    self.present(gotTicketsVc, animated: true, completion: nil)
                }else{
                    if strError == "Coupon not exists" || strError == "クーポンは存在しません"{
                        showAlert(title: NSLocalizedString("The corresponding code does not exist.", comment: ""), message: NSLocalizedString("Please double check the code you entered.", comment: ""), controller: self)
                    }else {
                        showAlert(title: "Drinks", message: strError!, controller: self)
                    }
                }
            }
        }
    }
    
}
