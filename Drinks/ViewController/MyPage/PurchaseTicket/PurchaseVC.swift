//
//  PurchaseVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PurchaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionPurchaseBtn(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
