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
        
        let text = "Use my referal code and get free tickets.\nReferal code:\(lblMyCode.text!)"
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTermsAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnUseCodeAction(_ sender: AnyObject) {
        if txtFldCode.text!.isStringEmpty() == true{
            showAlert(title: "Drinks", message: "Please enter coupon code.", controller: self)
        }else if txtFldCode.text! == lblMyCode.text! {
            showAlert(title: "Drinks", message: "You can not use your own coupon", controller: self)
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
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            }
        }
    }
    
}
