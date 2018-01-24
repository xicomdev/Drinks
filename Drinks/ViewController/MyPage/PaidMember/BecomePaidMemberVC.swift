//
//  BecomePaidMemberVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 22/01/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class BecomePaidMemberVC: UIViewController {

    var callbackDelegate : MSProtocolCallback!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionBecomeMember(_ sender: Any) {
        self.dismiss(animated: true) {
            self.callbackDelegate.actionBackDismiss!()
        }
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
