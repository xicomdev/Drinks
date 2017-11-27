//
//  GroupLocationCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupLocationCell: UITableViewCell {

    var group : Group? = nil
    @IBOutlet weak var lblLastLogin: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblMemberCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellInfo(groupDetail : Group)
    {
        group = groupDetail
        if group != nil
        {
            setNoOfMembers(groups: (group?.groupConditions)!, label: self.lblMemberCount, relation:(group?.relationship)!)
            let firstLoc = group?.location?.LocationName!.components(separatedBy: ",").first
            let distanceStr = String(format: "%.2f", (group?.distance)!)
            lblLocation.text = firstLoc! + "\n(\(distanceStr)km)"
            
            if group?.groupBy == .Other
            {
                lblLastLogin.text = group?.groupOwner.lastLogin.getTimeFromDate()
            }else{
                lblLastLogin.text = appLastLoginFormat.string(from: Date())
            }
        }
    }

    
}
