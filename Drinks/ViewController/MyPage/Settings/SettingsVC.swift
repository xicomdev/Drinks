//
//  SettingsVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblVwSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.hidesBackButton = true
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsVC.btnCrossAction))
        
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navTitle(title: "Settings" as NSString, color: UIColor.black , font:  FontRegular(size: 18))

        tblVwSettings.registerNibsForCells(arryNib: ["SettingsCell"])
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblVwSettings.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        tblVwSettings.delegate = self
        tblVwSettings.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }

    @IBAction func btnCrossAction(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arySettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arySettings[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerVw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
        if section == 0 {
            headerVw.lblHeader.text = "When in trouble"
        }else {
            headerVw.lblHeader.text = "Other"
        }
        headerVw.backgroundColor = APP_GrayColor
        return headerVw
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = (arySettings[indexPath.section])[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0  && indexPath.row == 0
        {
            
            LoginManager.sharedInstance.logOut(handler: { (success, response, strError) in
                if success
                {
                    getOutOfApp()
                    
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }

            })
        }
    }
}
