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

        tblvwHelp.registerNibsForCells(arryNib: ["SettingsCell"])
        tblvwHelp.delegate = self
        tblvwHelp.dataSource = self
        tblvwHelp.reloadData()

    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Tableview delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryHelp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvwHelp.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = aryHelp[indexPath.row]
        return cell
    }

}
