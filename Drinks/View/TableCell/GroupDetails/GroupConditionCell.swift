//
//  GroupConditionCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupConditionCell: UITableViewCell {

    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblConditionInfo: UILabel!
    
    var condition : GroupCondition? = nil
    @IBOutlet weak var imgViewUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgViewUser.cornerRadius(value: 17.5)
        
      //  lblCounter.cornerRadius(value: 17.5)
        imgViewUser.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)

       // lblCounter.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignData(condition : GroupCondition, counter : Int){
        
        self.condition = condition
        
        if Locale.preferredLanguages[0].contains("en") {
            lblConditionInfo.text = condition.age.description + " / " + condition.occupation.engName
        }else {
            lblConditionInfo.text = condition.age.description + " / " + condition.occupation.japName
        }
        
        
    }

    
}
