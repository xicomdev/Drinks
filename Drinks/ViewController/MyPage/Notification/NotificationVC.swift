//
//  NotificationVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblVwNotification: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.tintColor = .black
        
       
//        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationVC.actionBtnBackPressed))
//
//           let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationVC.actionBtnDonePressed))
//
//          self.navigationItem.rightBarButtonItem = btnRightBar
//        self.navigationItem.leftBarButtonItem = btnLeftBar
//
//        self.navTitle(title: "Notifications" as NSString, color: UIColor.black , font:  FontRegular(size: 19))
        
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblVwNotification.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        
        tblVwNotification.registerNibsForCells(arryNib: ["NotificationCell"])
        tblVwNotification.delegate = self
        tblVwNotification.dataSource = self
    }

    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionSaveBtn(_ sender: Any) {
        LoginManager.sharedInstance.updateNotifications{ (success, response, strError) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
    
   
    
    //MARK:- Tableview delegate and datasource methods
    //MARK:-
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView : SelectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
        headerView.lblHeader.text = "Push Notification"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.btnSwitch.addTarget(self, action: #selector(self.switchActon(_:)), for: .valueChanged)
        cell.btnSwitch.tag = indexPath.row
        switch indexPath.row {
        case 0:
            cell.btnSwitch.isOn = LoginManager.getMe.notificationSettings.newOffer
        case 1:
            cell.btnSwitch.isOn = LoginManager.getMe.notificationSettings.match
        case 2:
            cell.btnSwitch.isOn = LoginManager.getMe.notificationSettings.message
        case 3:
            cell.btnSwitch.isOn = LoginManager.getMe.notificationSettings.notice
        default:
            break
        }
        
        cell.lblTitle.text = aryNotification[indexPath.row]
        
        return cell
    }
    
    func switchActon(_ sender: UISwitch)
    {
        switch sender.tag {
        case 0:
            LoginManager.getMe.notificationSettings.newOffer = !(LoginManager.getMe.notificationSettings.newOffer)
        case 1:
            LoginManager.getMe.notificationSettings.match = !(LoginManager.getMe.notificationSettings.match)
        case 2:
            LoginManager.getMe.notificationSettings.message = !(LoginManager.getMe.notificationSettings.message)
        case 3:
            LoginManager.getMe.notificationSettings.notice = !(LoginManager.getMe.notificationSettings.notice)
        default:
            break
        }
    }
}
