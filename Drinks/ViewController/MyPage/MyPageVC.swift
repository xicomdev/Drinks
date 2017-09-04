//
//  MyPageVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
        
        self.navigationController?.isNavigationBarHidden = false
        let NavBtnNib = UINib(nibName: "MyPageNavBtnCell", bundle: nil)
        collctnVwNavBtns.register(NavBtnNib, forCellWithReuseIdentifier: "MyPageNavBtnCell")
        
        let groupNib = UINib(nibName: "MyPageGroupsCell", bundle: nil)
        collctnVwGroups.register(groupNib, forCellWithReuseIdentifier: "MyPageGroupsCell")
        
        let noOfLines = aryMyPageNavBtns.count % 3 == 0 ? aryMyPageNavBtns.count / 3 : (aryMyPageNavBtns.count/3) + 1
        clctnNavBtnHgt.constant = CGFloat(noOfLines * Int(self.view.frame.width/3))
        collctnVwNavBtns.isScrollEnabled = false
        
        imgVwDP.image = #imageLiteral(resourceName: "UserPlaceHolder")
        imgVwDP.layer.cornerRadius = self.view.frame.width/6
        
        collctnVwNavBtns.delegate = self
        collctnVwNavBtns.dataSource = self
        collctnVwNavBtns.reloadData()
        collctnVwGroups.delegate = self
        collctnVwGroups.dataSource = self
        collctnVwGroups.reloadData()
    }

    @IBAction func btnStatusAction(_ sender: AnyObject) {
    }
    
    @IBAction func btnTicketAction(_ sender: AnyObject) {
    }
    
    @IBAction func btnOfferAction(_ sender: AnyObject) {
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
            return CGSize(width: (self.view.frame.width/3)-2, height: (self.view.frame.width/3)-2)
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
                self.present(paidMemberVc, animated: true, completion:nil)
            case 2:
                let ageVerifyVc = mainStoryBoard.instantiateViewController(withIdentifier: "AgeVerificationDetailsVC") as! AgeVerificationDetailsVC
                self.present(ageVerifyVc, animated: true, completion:nil)
            case 5:
                let couponVc = mainStoryBoard.instantiateViewController(withIdentifier: "CouponVC") as! CouponVC
                self.present(couponVc, animated: true, completion:nil)
            default:
                break
            }
        }
    }
}
