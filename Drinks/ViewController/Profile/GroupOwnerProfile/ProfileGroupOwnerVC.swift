//
//  ProfileGroupOwnerVC.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Firebase

class ProfileGroupOwnerVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tblProfile: UITableView!
    
    var ownerUser : User!
    var isOnline = Bool()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "CrossActive"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileGroupOwnerVC.actionBtnBackPressed))
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        
       let strTitle =  self.ownerUser.fullName + " (\(self.ownerUser.age))"
        self.navTitle(title: strTitle as NSString , color: .black, font: FontRegular(size: 18))
        
        tblProfile.registerNibsForCells(arryNib: ["ProfileGroupOwnerCell" , "OwnerInfoCell" ])
        tblProfile.delegate = self
        tblProfile.dataSource = self
        
        Analytics.logEvent("View_user_profile", parameters: nil)
        checkUserOnline()


        // Do any additional setup after loading the view.
    }

    func checkUserOnline() {
        SwiftLoader.show(true)
        let param = ["user_id": ownerUser.ID]
        HTTPRequest.sharedInstance().postRequest(urlLink: APi_checkUserOnline, paramters: param) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            print(response)
            if isSuccess
            {
                self.isOnline = (response as! NSDictionary)["is_login"] as! Bool
                self.tblProfile.reloadData()
                //getOutOfApp()
            }else{
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func actionBtnBackPressed(){
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            if indexPath.row == 0
            {
                return ScreenWidth / 1.7
            }
                return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"ProfileGroupOwnerCell") as! ProfileGroupOwnerCell
                if self.isOnline {
                    cell.lblTag.text = NSLocalizedString("Online", comment: "")
                }else {
                    cell.lblTag.text = NSLocalizedString("Offline", comment: "")
                }
                cell.setCornerRadius()
                cell.assignUserInfo(user: ownerUser)
                
                return cell
                
            }
        let cell = tableView.dequeueReusableCell(withIdentifier:"OwnerInfoCell") as! OwnerInfoCell
        
        
        if indexPath.row == 1
        {
            
            cell.lblInfoType.text = NSLocalizedString("Blood Type", comment: "")
            cell.lblValue.text = self.ownerUser.bloodGroup

        }else if  indexPath.row == 2
        {
            cell.lblInfoType.text = NSLocalizedString("Marriage History", comment: "")
            cell.lblValue.text = self.ownerUser.relationship

        }
        else if  indexPath.row == 3
        {
            cell.lblInfoType.text = NSLocalizedString("Tobacco", comment: "")
            cell.lblValue.text = self.ownerUser.tabaco

        }
        else if  indexPath.row == 4
        {
            cell.lblInfoType.text = NSLocalizedString("School Career", comment: "")
            cell.lblValue.text = self.ownerUser.schoolCareer

        }
        else if  indexPath.row == 5
        {
            cell.lblInfoType.text = NSLocalizedString("Annual Income", comment: "")
            cell.lblValue.text = self.ownerUser.annualIncome
        }
         return cell
        
        }
        
}
