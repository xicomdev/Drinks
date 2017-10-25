//
//  MyPageVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet var imgViewCoverPic: UIImageView!
    
    @IBOutlet weak var clctnNavBtnHgt: NSLayoutConstraint!
    @IBOutlet weak var collctnVwNavBtns: UICollectionView!
    @IBOutlet weak var collctnVwGroups: UICollectionView!
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var lblTickets: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var imgVwDP: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
               self.view.layoutIfNeeded()
        
        //Full Screen (Remove top Padding)
         self.edgesForExtendedLayout = UIRectEdge.top
        let NavBtnNib = UINib(nibName: "MyPageNavBtnCell", bundle: nil)
        collctnVwNavBtns.register(NavBtnNib, forCellWithReuseIdentifier: "MyPageNavBtnCell")
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = "version " + version
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.updateUI()
        LoginManager.sharedInstance.getUserDetail{ (success, response, strError) in
            if success{
                self.updateUI()
                    
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
   
    func updateUI() {
        lblTickets.text = LoginManager.getMe.myCredits
        lblOffers.text = LoginManager.getMe.offersCount
        lblStatus.text = LoginManager.getMe.membershipStatus
        imgVwDP.cornerRadius(value: self.view.frame.width/6)
        imgVwDP.sd_setImage(with: URL(string: LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)
        imgViewCoverPic.sd_setImage(with: URL(string: LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)
        lblNameAge.text = "\(LoginManager.getMe.fullName!) (\(LoginManager.getMe.age))"
        lblOccupation.text =  LoginManager.getMe.job.engName
        
        let noOfLines = aryMyPageNavBtns.count % 3 == 0 ? aryMyPageNavBtns.count / 3 : (aryMyPageNavBtns.count/3) + 1
        clctnNavBtnHgt.constant = CGFloat(noOfLines * Int(self.view.frame.width/3))
        collctnVwNavBtns.isScrollEnabled = true
        
        collctnVwNavBtns.delegate = self
        collctnVwNavBtns.dataSource = self
    }
    
    @IBAction func btnStatusAction(_ sender: AnyObject) {
        let paidMemberVc = mainStoryBoard.instantiateViewController(withIdentifier: "PaidMemberVC") as! PaidMemberVC
        paidMemberVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(paidMemberVc, animated: true)
    }
    
    @IBAction func btnTicketAction(_ sender: AnyObject) {
        let ticketVc = mainStoryBoard.instantiateViewController(withIdentifier: "PurchaseTicketVC") as! PurchaseTicketVC
        ticketVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ticketVc, animated: true)
    }
    
    @IBAction func btnOfferAction(_ sender: AnyObject) {
        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
        tabBarController.selectedIndex = 1
        appDelegate().window?.rootViewController = tabBarController
    }
    
    //MARK: - CollectionView Delegate and datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collctnVwNavBtns {
            return aryMyPageNavBtns.count
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collctnVwNavBtns {
            return CGSize(width: (self.view.frame.width/3), height: (self.view.frame.width/3))
        }else {
            return CGSize(width: (self.view.frame.width * 2)/3, height: collctnVwGroups.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collctnVwNavBtns {
            let cell = collctnVwNavBtns.dequeueReusableCell(withReuseIdentifier: "MyPageNavBtnCell", for: indexPath) as! MyPageNavBtnCell
            cell.lblBtnName.text = aryMyPageNavBtns[indexPath.row].1
            cell.imgVwBtnIcon.image = aryMyPageNavBtns[indexPath.row].0
            return cell
        }else {
            let cell = collctnVwGroups.dequeueReusableCell(withReuseIdentifier: "MyPageGroupsCell", for: indexPath) as! MyPageGroupsCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collctnVwNavBtns {
            switch indexPath.item {
            case 0:
                let paidMemberVc = mainStoryBoard.instantiateViewController(withIdentifier: "PaidMemberVC") as! PaidMemberVC
                paidMemberVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(paidMemberVc, animated: true)
            case 1:
                let ticketVc = mainStoryBoard.instantiateViewController(withIdentifier: "PurchaseTicketVC") as! PurchaseTicketVC
                ticketVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ticketVc, animated: true)
            case 2:
                let profileVc = mainStoryBoard.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
                profileVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(profileVc, animated: true)
            case 3:
                let settingVc = mainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                settingVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(settingVc, animated: true)
            case 4:
                let couponVc = mainStoryBoard.instantiateViewController(withIdentifier: "CouponVC") as! CouponVC
                couponVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(couponVc, animated: true)
            case 5:
                let notificationVc = mainStoryBoard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                notificationVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(notificationVc, animated: true)
            case 6:
                let helpVc = mainStoryBoard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
                helpVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(helpVc, animated: true)
            default:
                break
            }
        }
    }
}
