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
            if Locale.preferredLanguages[0].contains("en") {
                lblPlanDuration.text = plan.engName
                lblPlanPrice.text = plan.engDesc
            }else {
                lblPlanDuration.text = plan.japName
                lblPlanPrice.text = plan.japDesc
            }
            lblDiscount.isHidden = true
            lblPopulartyNo.isHidden = true
        }else {
            btnBuy.setTitle(NSLocalizedString("Buy", comment: ""), for: .normal)
            lblPlanPrice.text = "¥\(Int(plan.amount))/\(NSLocalizedString("mon", comment: ""))"
            lblDiscount.text = "¥\(NSNumber(value: plan.discount)) \(NSLocalizedString("discount!", comment: ""))"
            if Locale.preferredLanguages[0].contains("en") {
                lblPlanDuration.text = plan.engName
                lblPopulartyNo.text = plan.engDesc
            }else {
                lblPlanDuration.text = plan.japName
                lblPopulartyNo.text = plan.japDesc
            }
            lblDiscount.isHidden = false
            lblPopulartyNo.isHidden = false
        }
    }
    
    @IBAction func actionBtnBuyPlan(_ sender: UIButton) {
        if callbackBuy != nil{
            self.callbackBuy!(plan)
        }
    }
    
}
