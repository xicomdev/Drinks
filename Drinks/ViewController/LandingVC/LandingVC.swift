//
//  LandingVC.swift
//  Drinks
//
//  Created by maninder on 7/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class LandingVC: UIViewController,UIScrollViewDelegate {
    
    var scrlWidth  : CGFloat = 0.0
    var scrlHeight  : CGFloat = 0.0

    @IBOutlet var pageControl: UIPageControl!

    @IBOutlet var scrlViewImages: UIScrollView!
    @IBOutlet var btnFBLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        scrlWidth = self.scrlViewImages.frame.size.width
        scrlHeight = self.scrlViewImages.frame.size.height
        scrlViewImages.delegate = self
        scrlViewImages.isScrollEnabled = true;
        
        scrlViewImages.decelerationRate = UIScrollViewDecelerationRateNormal;
        scrlViewImages.contentSize = CGSize(width: scrlWidth*4, height: scrlHeight)
        
        
        
        let firstImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scrlWidth, height: scrlHeight))
        firstImage.image = landLogo
        firstImage.contentMode = .center
        let secondImage = UIImageView(frame: CGRect(x: scrlWidth, y: 0, width: scrlWidth, height: scrlHeight))
        secondImage.image = landLogo
        secondImage.contentMode = .center

        let thirdImage = UIImageView(frame: CGRect(x:scrlWidth*2, y: 0, width: scrlWidth, height: scrlHeight))
        thirdImage.image = landLogo
        thirdImage.contentMode = .center

        let forthImage = UIImageView(frame: CGRect(x: scrlWidth*3, y: 0, width: scrlWidth, height: scrlHeight))
        forthImage.image = landLogo
        forthImage.contentMode = .center

 
        scrlViewImages.addSubview(firstImage)
        scrlViewImages.addSubview(secondImage)
        scrlViewImages.addSubview(thirdImage)
        scrlViewImages.addSubview(forthImage)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
            appDelegate().window?.rootViewController = tabBarController
        }
    }

    
    
    
    
    @IBAction func actionBtnLoginPressed(_ sender: Any) {

      /*   let camera =  self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(camera, animated: true)
 */
       
   
        FBManager.sharedInstance.currentUserProfile(viewController: self) { (success, response, strError) in
            
            if success == true{
                if let dictFB = response as? Dictionary <String , Any>
                {
                    
                   LoginManager.getMe.firstName = dictFB["first_name"] as! String
                      LoginManager.getMe.lastName = dictFB["last_name"] as! String
                      LoginManager.getMe.socialID = dictFB["id"] as! String
                    LoginManager.getMe.fullName = LoginManager.getMe.firstName + " " +  LoginManager.getMe.lastName
                    LoginManager.getMe.imageURL = String(format: "http://graph.facebook.com/%@/picture?type=large", LoginManager.getMe.socialID)
                    self.checkUserExists()
                    
                }
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    
    }
    
    
    //MARK:- ScrolViewDelegates
    //MARK:-
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)

    }
    
    
    func checkUserExists()
    {
        LoginManager.sharedInstance.checkUserExists { (success, response, strError) in
            if success{
                if let existingUser = response as? User
                {
                    let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                 //   AppDelegate
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    
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
