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

        tblVwNotification.registerNibsForCells(arryNib: ["NotificationCell"])
        tblVwNotification.tableFooterView = UIView()
        tblVwNotification.delegate = self
        tblVwNotification.dataSource = self
        tblVwNotification.reloadData()
    }

    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    //MARK: - Tableview delegate and datsource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.btnSwitch.addTarget(self, action: #selector(self.switchActon(_:)), for: .valueChanged)
        cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.isOn = aryNotification[indexPath.row]["boolValue"] as! Bool
        cell.lblTitle.text = aryNotification[indexPath.row]["title"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func switchActon(_ sender: UISwitch) {
        aryNotification[sender.tag].updateValue(!(aryNotification[sender.tag]["boolValue"] as! Bool), forKey: "boolValue")
    }
}
