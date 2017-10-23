//
//  GotCouponTicketVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/1/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GotCouponTicketVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnFindOpponentAction(_ sender: AnyObject) {
        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
        appDelegate().window?.rootViewController = tabBarController
    }
    
    @IBAction func btnCloseAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
