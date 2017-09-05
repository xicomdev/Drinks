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
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnShareCodeAction(_ sender: AnyObject) {
        
        let text = "This is some text that I want to share."
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnTermsAction(_ sender: AnyObject) {
    }
    
    @IBAction func btnUseCodeAction(_ sender: AnyObject) {
    }
    
    
}
