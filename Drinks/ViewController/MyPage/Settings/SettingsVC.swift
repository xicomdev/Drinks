//
//  SettingsVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tblVwSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblVwSettings.registerNibsForCells(arryNib: ["SettingsCell"])
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblVwSettings.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        tblVwSettings.delegate = self
        tblVwSettings.dataSource = self
        
        self.view.backgroundColor = APP_GrayColor
        
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
            headerVw.lblHeader.text = NSLocalizedString("When in trouble", comment: "")
        }else {
            headerVw.lblHeader.text = NSLocalizedString("Other", comment: "")
        }
        headerVw.backgroundColor = APP_GrayColor
        return headerVw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = NSLocalizedString((arySettings[indexPath.section])[indexPath.row], comment: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0  && indexPath.row == 0 {
            
            LoginManager.sharedInstance.logOut(handler: { (success, response, strError) in
                if success
                {
                    getOutOfApp()
                    
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }

            })
        }else if indexPath.section == 0  && indexPath.row == 2 {
            sendEmail()
        }else if indexPath.section == 1  && indexPath.row == 0 {
            rateApp(appId: "", completion: { (_) in
                
            })
        }else if indexPath.section == 1  && indexPath.row == 3 {
            let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
            genericVc.strTitle = "Commercial Transaction"
            self.navigationController?.pushViewController(genericVc, animated: true)
        }else {
            let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
            genericVc.strTitle = (arySettings[indexPath.section])[indexPath.row]
            self.navigationController?.pushViewController(genericVc, animated: true)
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
