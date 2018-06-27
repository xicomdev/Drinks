//
//  AgeVerificationPopupVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 15/02/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class AgeVerificationPopupVC: UIViewController {
    
    var callbackDelegate : MSProtocolCallback!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionAuthenticate(_ sender: Any) {
        self.dismiss(animated: true) {
            self.callbackDelegate.actionMoveToPreviousVC!()
        }
    }
    
    @IBAction func actionCloseup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
