//
//  PurchaseTicketVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/5/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PurchaseTicketVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblVwTicketPlans: UITableView!
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!

    var aryPlansCount = [4,2]

    override func viewDidLoad() {
        super.viewDidLoad()

        tblHeightConst.constant = CGFloat((aryPlansCount[0]*80) + (aryPlansCount[1]*60)) + 30
        tblVwTicketPlans.registerNibsForCells(arryNib: ["PurchaseTicketCell", "SettingsCell"])
        tblVwTicketPlans.delegate = self
        tblVwTicketPlans.dataSource = self
    }

    @IBAction func actionBtnCross(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - TableView delegate and datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aryPlansCount.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryPlansCount[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let headerVw = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            headerVw.backgroundColor = APP_GrayColor
            return headerVw
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblVwTicketPlans.dequeueReusableCell(withIdentifier: "PurchaseTicketCell", for: indexPath) as! PurchaseTicketCell
            cell.callbackBuy = {() in
                
                self.actionBuyBtn()
                
                
            }
            return cell
        }else {
            let cell = tblVwTicketPlans.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return cell
        }
        
    }
    
    func actionBuyBtn() {
//        let buyTicketVc = mainStoryBoard.instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
//        self.present(buyTicketVc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
