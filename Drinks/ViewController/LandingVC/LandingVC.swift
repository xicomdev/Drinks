//
//  LandingVC.swift
//  Drinks
//
//  Created by maninder on 7/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet var btnFBLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnLoginPressed(_ sender: Any) {
        
        
//        let profileVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileFirstVC") as! ProfileFirstVC
//        self.navigationController?.pushViewController(profileVC, animated: true)
        
        
        FBManager.sharedInstance.currentUserProfile(viewController: self) { (success, response, strError) in
            
            if success == true{
                if let dictFB = response as? Dictionary <String , Any> {
                    
                    print(dictFB)
                    
                    
                   LoginManager.getMe.firstName = dictFB["first_name"] as! String
                      LoginManager.getMe.lastName = dictFB["last_name"] as! String
                      LoginManager.getMe.socialID = dictFB["id"] as! String
                    LoginManager.getMe.fullName = LoginManager.getMe.firstName + " " +  LoginManager.getMe.lastName
                    
                    LoginManager.getMe.imageURL = String(format: "http://graph.facebook.com/%@/picture?type=large", LoginManager.getMe.socialID)

//                    
//                    let profileVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileFirstVC") as! ProfileFirstVC
//                    self.navigationController?.pushViewController(profileVC, animated: true)
                    self.checkUserExists()
//                                        if let email =  dictFB["email"] as? String
//                                        {
//                                            LoginManager.getMe.emailAddress = email
//                                            self.registerOrLoginWithFB()
//                                        }else{
//                                            //  showAlertCustom(message: "Facebook account is private", btnTitle: "Ok", controller: self)
//                                            let confirmEmail = mainStoryBoard.instantiateViewController(withIdentifier: "EnterEmailVC") as! EnterEmailVC
//                                            self.navigationController?.pushViewController(confirmEmail, animated: true)
//                                        }
                }
            }else{
                
            print(strError)
                
                
            }
        }
        
    }
    
    
    func checkUserExists()
    {
        LoginManager.sharedInstance.checkUserExists { (success, response, strError) in
            if success{
                if let existingUser = response as? User{
                    
                    print(existingUser)
                }else{
                       let profileVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileFirstVC") as! ProfileFirstVC
                        self.navigationController?.pushViewController(profileVC, animated: true)
                }
                
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
            
        }
        
    }
}
