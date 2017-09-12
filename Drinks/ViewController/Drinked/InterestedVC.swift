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
        
        self.perform(#selector(InterestedVC.dismissSelf), with: nil, afterDelay: 4)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
