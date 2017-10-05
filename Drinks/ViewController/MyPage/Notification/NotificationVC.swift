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

        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
       
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationVC.actionBtnBackPressed))
        
           let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationVC.actionBtnDonePressed))
        
          self.navigationItem.rightBarButtonItem = btnRightBar
        self.navigationItem.leftBarButtonItem = btnLeftBar

        self.navTitle(title: "Notifications" as NSString, color: UIColor.black , font:  FontRegular(size: 19))

        
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblVwNotification.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        
        tblVwNotification.registerNibsForCells(arryNib: ["NotificationCell"])
        tblVwNotification.delegate = self
        tblVwNotification.dataSource = self
    }

    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    func actionBtnBackPressed(){
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
     func actionBtnDonePressed(){
        
        self.navigationController?.popViewController(animated: true)

    }
    //MARK:- Tableview delegate and datasource methods
    //MARK:-
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57
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
        
        cell.btnSwitch.isEnabled = aryNotification[indexPath.row]["boolValue"] as! Bool
        
        cell.lblTitle.text = aryNotification[indexPath.row]["title"] as? String
        
        
        
        return cell
    }
    
    func switchActon(_ sender: UISwitch)
    {
        
       // aryNotification[sender.tag].updateValue(!(aryNotification[sender.tag]["boolValue"] as! Bool), forKey: "boolValue")
    }
}
