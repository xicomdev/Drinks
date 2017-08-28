//
//  DescriptionCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var lblInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func assignGroupInfo(group : Group)
    {
        if group != nil{
            lblInfo.text = group.groupDescription
        }
    }
    
    
}
