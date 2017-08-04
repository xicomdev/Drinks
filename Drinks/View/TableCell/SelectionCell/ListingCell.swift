//
//  ListingCell.swift
//  SNAP VV
//
//  Created by maninder on 3/16/17.
//  Copyright © 2017 Kajal. All rights reserved.
//

import UIKit

class ListingCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var imgViewSelection: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
