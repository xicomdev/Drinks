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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignMember(plan : PremiumPlan)
    {
        self.plan = plan
        lblPlanPrice.text = "¥\(NSNumber(value: plan.amount))/mon"
        lblDiscount.text = "¥\(NSNumber(value: plan.discount)) discount!"
        lblPopulartyNo.text = plan.planDescription
        lblPlanDuration.text = plan.engName
    }
    
    @IBAction func actionBtnBuyPlan(_ sender: UIButton) {
        if callbackBuy != nil{
            self.callbackBuy!(plan)
        }
    }
    
}
