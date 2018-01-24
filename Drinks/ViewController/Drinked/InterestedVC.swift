//
//  InterestedVC.swift
//  Drinks
//
//  Created by maninder on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class InterestedVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        self.perform(#selector(InterestedVC.dismissSelf), with: nil, afterDelay: 1.5)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlertWithAnimation(object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSelf(){
        hideAlertWithAnimation(object: self) { (call) in
            //DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
           // })
        }
    }
    
}
