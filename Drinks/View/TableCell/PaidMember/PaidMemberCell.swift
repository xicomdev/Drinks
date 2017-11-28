//
//  PaidMemberCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PaidMemberCell: UITableViewCell {

    var callbackBuy : ((PremiumPlan)-> Void)? = nil

    var plan : PremiumPlan!
    @IBOutlet weak var btnBuy: SetCornerButton!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    @IBOutlet weak var lblPopulartyNo: UILabel!
    @IBOutlet weak var lblPlanDuration: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnBuy.setTitle(NSLocalizedString("Buy", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignMember(plan : PremiumPlan)
    {
        self.plan = plan
        if plan.engName.contains("day") || plan.engName.contains("Day") || plan.engName.contains("Days") || plan.engName.contains("days"){
            btnBuy.setTitle(NSLocalizedString("Exchange", comment: ""), for: .normal)
            lblPlanPrice.text = plan.planDescription
            lblDiscount.isHidden = true
            lblPopulartyNo.isHidden = true
        }else {
            btnBuy.setTitle(NSLocalizedString("Buy", comment: ""), for: .normal)
            lblPlanPrice.text = "¥\(Int(plan.amount))/\(NSLocalizedString("mon", comment: ""))"
            lblDiscount.text = "¥\(NSNumber(value: plan.discount)) \(NSLocalizedString("discount!", comment: ""))"
            lblPopulartyNo.text = plan.planDescription
            lblDiscount.isHidden = false
            lblPopulartyNo.isHidden = false
        }
        lblPlanDuration.text = plan.engName
    }
    
    @IBAction func actionBtnBuyPlan(_ sender: UIButton) {
        if callbackBuy != nil{
            self.callbackBuy!(plan)
        }
    }
    
}
