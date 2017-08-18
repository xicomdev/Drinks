//
//  GroupOwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupOwnerCell: UITableViewCell {

    @IBOutlet weak var imgViewOwner: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewOwner.cornerRadius(value: 17.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
