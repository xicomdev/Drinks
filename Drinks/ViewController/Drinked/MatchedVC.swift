//
//  MatchedVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MatchedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.alpha = 0
        self.perform(#selector(MatchedVC.dismissSelf), with: nil, afterDelay: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool){
        showAlertWithAnimation(object: self)
        
    }
  
    func dismissSelf(){
        hideAlertWithAnimation(object: self) { (call) in
            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
            tabBarController.selectedIndex = 2
            appDelegate().window?.rootViewController = tabBarController
            
        }
    }
    
}
