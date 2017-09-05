//
//  PaidMemberVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PaidMemberVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblVwPlans: UITableView!
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    
    var aryPlansCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblHeightConst.constant = CGFloat(aryPlansCount*80)
        tblVwPlans.registerNibsForCells(arryNib: ["PaidMemberCell"])
        tblVwPlans.delegate = self
        tblVwPlans.dataSource = self
        tblVwPlans.reloadData()
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }    
   
    //MARK: - TableView delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryPlansCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tblVwPlans.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwPlans.dequeueReusableCell(withIdentifier: "PaidMemberCell", for: indexPath) as! PaidMemberCell
        return cell
    }
    
}
