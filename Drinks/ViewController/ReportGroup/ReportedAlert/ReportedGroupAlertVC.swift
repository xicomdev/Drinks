//
//  ReportedGroupAlertVC.swift
//  Drinks
//
//  Created by maninder on 9/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ReportedGroupAlertVC: UIViewController {
    
    var delegate : MSProtocolCallback? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        self.perform(#selector(ReportedGroupAlertVC.dismissVC), with: nil, afterDelay: 1.5)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        showAlertWithAnimation(object: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissVC(){
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
                if self.delegate != nil{
                  //  self.delegate?.actionBackDismiss!()
                }
            })
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
