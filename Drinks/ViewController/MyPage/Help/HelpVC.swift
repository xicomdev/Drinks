//
//  HelpVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class HelpVC: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tblvwHelp: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblvwHelp.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        tblvwHelp.registerNibsForCells(arryNib: ["SettingsCell"])
        tblvwHelp.delegate = self
        tblvwHelp.dataSource = self
        tblvwHelp.reloadData()
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Tableview delegate and datasource methods
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView : SelectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
        headerView.lblHeader.text = NSLocalizedString("Beginner's Guide", comment: "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryHelp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvwHelp.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = NSLocalizedString(aryHelp[indexPath.row], comment: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == aryHelp.count - 1 {
            let leaveVC = mainStoryBoard.instantiateViewController(withIdentifier: "WithdrawalVC") as! WithdrawalVC
            self.navigationController?.pushViewController(leaveVC, animated: true)
        }else {
            let genericVc = mainStoryBoard.instantiateViewController(withIdentifier: "GenericPageVC") as! GenericPageVC
            genericVc.strTitle = "Help"
            switch indexPath.row {
            case 0:
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_whtsDrinks
                }else {
                    genericVc.apiURL = API_whtsDrinksJap
                }
            case 1:
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_confidence
                }else {
                    genericVc.apiURL = API_confidenceJap
                }
            case 2:
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_violationPolicy
                }else {
                    genericVc.apiURL = API_violationPolicyJap
                }
            case 3:
                if Locale.preferredLanguages[0].contains("en") {
                    genericVc.apiURL = API_raiseMatchingRate
                }else {
                    genericVc.apiURL = API_raiseMatchingRateJap
                }
            default:
                break
            }
            self.navigationController?.pushViewController(genericVc, animated: true)
        }
    }

}
