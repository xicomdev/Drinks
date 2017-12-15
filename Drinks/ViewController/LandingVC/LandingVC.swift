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

    @IBOutlet var imgViewBG: UIImageView!
    
    @IBOutlet var imgViewBG2: UIImageView!
    
    
    @IBOutlet var imgViewBG3: UIImageView!
    
    
    @IBOutlet var imgViewBG4: UIImageView!
    
    @IBOutlet var btnTermsOfUse: UIButton!
    @IBOutlet var btnPrivacyPolicy: UIButton!
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
        
        btnPrivacyPolicy.underlineButton(text: NSLocalizedString("Privacy policy", comment: ""), font: FontRegular(size: 14))
        btnTermsOfUse.underlineButton(text: NSLocalizedString("Terms of use", comment: ""), font: FontRegular(size: 14))
       
        
        let firstImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scrlWidth, height: scrlHeight))
        firstImage.image = WT1
        firstImage.contentMode = .center
        let secondImage = UIImageView(frame: CGRect(x: scrlWidth, y: 0, width: scrlWidth, height: scrlHeight))
        secondImage.image = WT2
        secondImage.contentMode = .center

        let thirdImage = UIImageView(frame: CGRect(x:scrlWidth*2, y: 0, width: scrlWidth, height: scrlHeight))
        thirdImage.image = WT3
        thirdImage.contentMode = .center

        let forthImage = UIImageView(frame: CGRect(x: scrlWidth*3, y: 0, width: scrlWidth, height: scrlHeight))
        forthImage.image = WT4
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

        let alert = UIAlertController(title: NSLocalizedString("Facebook Authentication", comment: ""), message: NSLocalizedString("We will access your birthday to complete your profile. Do you want to continue?", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (_) in
            FBManager.sharedInstance.currentUserProfile(viewController: self) { (success, response, strError) in
                
                if success == true{
                    if let dictFB = response as? Dictionary <String , Any>
                    {
                        
                        print(dictFB["id"] as! String)
                        LoginManager.getMe.firstName = dictFB["first_name"] as! String
                        LoginManager.getMe.lastName = dictFB["last_name"] as! String
                        LoginManager.getMe.socialID = dictFB["id"] as! String
                        LoginManager.getMe.fullName = LoginManager.getMe.firstName + " " +  LoginManager.getMe.lastName
                        LoginManager.getMe.imageURL = String(format: "http://graph.facebook.com/%@/picture?type=large", LoginManager.getMe.socialID)
                        if let birthday = dictFB["birthday"] as? String
                        {
                            if birthday != "" {
                                let formttr = DateFormatter()
                                formttr.dateFormat = "dd/MM/yyyy"
                                let dt = formttr.date(from: birthday)
                                if dt != nil {
                                    LoginManager.getMe.DOB = dateFormatter.string(from: dt!)
                                    LoginManager.getMe.age = LoginManager.getMe.DOB.getAgeFromDOB()
                                }
                                
                            }
                        }
                        
                        if dictFB["gender"] as! String == "male"
                        {
                            LoginManager.getMe.myGender = Gender.Male
                            
                        }else{
                            
                            LoginManager.getMe.myGender = Gender.Female
                            
                        }
                        if LoginManager.getMe.DOB != "" {
                            if LoginManager.getMe.age < 18 {
                                showAlert(title: "Drinks", message: NSLocalizedString("Your age is less than 18.\nSo you can not login to Drinks.", comment: ""), controller: self)
                                return
                            }
                        }
                        self.checkUserExists()
                        
                    }
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            }
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil)
       
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    
    }
    
    
    //MARK:- ScrolViewDelegates
    //MARK:-
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        
        if Int(pageNumber) == 0 {
            
            UIView.animate(withDuration: 0.3, animations: {

            self.imgViewBG.alpha = 1
                self.imgViewBG2.alpha = 0

                self.imgViewBG3.alpha = 0
                 self.imgViewBG4.alpha = 0

            
            })
            
        }else if Int(pageNumber) == 1
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.imgViewBG.alpha = 0
                self.imgViewBG2.alpha = 1
                
                self.imgViewBG3.alpha = 0
                self.imgViewBG4.alpha = 0
            })
            
        }else if Int(pageNumber) == 2
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.imgViewBG.alpha = 0
                self.imgViewBG2.alpha = 0
                
                self.imgViewBG3.alpha = 1
                self.imgViewBG4.alpha = 0
            })
            
        }else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.imgViewBG.alpha = 0
                self.imgViewBG2.alpha = 0
                
                self.imgViewBG3.alpha = 0
                self.imgViewBG4.alpha = 1
            })
        }
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
