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
    
    var arrayPackages : [PremiumPlan] = [PremiumPlan]()
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(PaidMemberVC.btnCrossAction))
        
    
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navTitle(title: NSLocalizedString("Premium", comment: "") as NSString, color: UIColor.black , font:  FontRegular(size: 18))

        
        self.getPlans()
        
        tblVwPlans.registerNibsForCells(arryNib: ["PaidMemberCell"])
        tblVwPlans.delegate = self
        tblVwPlans.dataSource = self
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: - TableView delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPackages.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        tblVwPlans.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwPlans.dequeueReusableCell(withIdentifier: "PaidMemberCell", for: indexPath) as! PaidMemberCell
        cell.assignMember(plan: arrayPackages[indexPath.row])
        cell.callbackBuy = {(plan : PremiumPlan) in
            self.makePayment(getPlan: plan)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getPlans()
    {
       PremiumPlan.getPremiumPlans { (success, response, strError) in
        if success
        {
            if let planList = response as? [PremiumPlan]
            {
                self.arrayPackages = planList
                 self.tblHeightConst.constant = CGFloat( self.arrayPackages.count*80)
                self.tblVwPlans.reloadData()
            }
            
        }else
        {
            showAlert(title: "Drinks", message: strError!, controller: self)
        }
        }
    }

 
    func makePayment(getPlan: PremiumPlan){
        if  getPlan.amount > 0.0 {
            ApplePayManager.sharedInstance.paymentVCForPremiumPlan(controller: self, plan: getPlan)
        }else {
            PurchaseFreePlan(getPlan)
        }
    }
    
    func PurchaseFreePlan(_ plan:PremiumPlan) {
        let params = [
            "plan_id":plan.planID
        ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_BuySelectedPlan, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                self.navigationController!.popViewController(animated: true)
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
}
