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
             setNoOfMembers(groups: (group?.groupConditions)!, label: self.lblMemberCount)
              lblLocation.text = group?.location?.LocationName!
            
            if group?.groupBy == .Other
            {
                lblLastLogin.text = group?.groupOwner.lastLogin
            }else{
                lblLastLogin.text = appLastLoginFormat.string(from: Date())
            }
            
        }
    }

    
}
