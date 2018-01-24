//
//  PremiumDoneVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 22/01/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class PremiumDoneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.alpha = 0
        self.perform(#selector(InterestedVC.dismissSelf), with: nil, afterDelay: 1.5)
    }

    override func viewDidAppear(_ animated: Bool){
        showAlertWithAnimation(object: self)
    }
    
    func dismissSelf(){
        hideAlertWithAnimation(object: self) { (call) in
            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
            tabBarController.selectedIndex = 3
            appDelegate().window?.rootViewController = tabBarController
            
        }
    }
    

}
