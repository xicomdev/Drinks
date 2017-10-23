//
//  SignupReferalCodeVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/16/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class SignupReferalCodeVC: UIViewController {

    @IBOutlet weak var txtfldCode: UITextField!
    
    var delegate : MSSelectionCallback? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionUseCodeBtn(_ sender: Any) {
        if txtfldCode.text!.isStringEmpty() == true{
            showAlert(title: "Drinks", message: "Please enter referal code.", controller: self)
        }else {
            SwiftLoader.show(true)

            let params = [
                "coupon_code":txtfldCode.text!
            ]
            HTTPRequest.sharedInstance().postRequest(urlLink: API_RedeemCoupon, paramters: params) { (isSuccess, response, strError) in
                SwiftLoader.hide()
                if isSuccess
                {
                    self.dismiss(animated: true) {
                        self.delegate?.gotoHome!()
                    }
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            }
        }
    }
    
    @IBAction func actionSkipBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.gotoHome!()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
