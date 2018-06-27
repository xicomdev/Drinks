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
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                LoginManager.sharedInstance.logOut(handler: { (success, response, strError) in
                    if success{
                        getOutOfApp()
                    }else{
                        showAlert(title: "Drinks", message: strError!, controller: self)
                    }
                })
                break
            case 1:
                let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
                genericVc.strTitle = (arySettings[indexPath.section])[indexPath.row]
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_HelpEng
                }else {
                    genericVc.apiURL = API_HelpJap
                }
                self.navigationController?.pushViewController(genericVc, animated: true)
                break
            case 2:
                sendEmail()
                break
            default:
                break
            }
        }else {
            switch indexPath.row {
            case 0:
                rateApp(appId: "", completion: { (_) in
                    
                })
                break
            case 1:
                let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
                genericVc.strTitle = (arySettings[indexPath.section])[indexPath.row]
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_TermsEng
                }else {
                    genericVc.apiURL = API_TermsJap
                }
                self.navigationController?.pushViewController(genericVc, animated: true)
                break
            case 2:
                let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
                genericVc.strTitle = (arySettings[indexPath.section])[indexPath.row]
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_PrivacyPolicyEng
                }else {
                    genericVc.apiURL = API_PrivacyPolicyJap
                }
                self.navigationController?.pushViewController(genericVc, animated: true)
                break
            case 3:
                let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as!  GenericPageVC
                genericVc.strTitle = "Commercial Transaction"
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_transactionEng
                }else {
                    genericVc.apiURL = API_transactionJap
                }
                self.navigationController?.pushViewController(genericVc, animated: true)
                break
            default :
                break
            }
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
            mail.setToRecipients(["support@drinks-jp.com"])
            mail.setSubject("DRINKSお問い合わせ")
            mail.setMessageBody("■お名前\n■お問い合わせ内容\n■お使いの端末・OS", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
