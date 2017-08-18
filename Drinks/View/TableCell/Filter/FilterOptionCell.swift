//
//  FilterOptionCell.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class FilterOptionCell: UITableViewCell {

    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet weak var imgViewNext: UIImageView!
    @IBOutlet weak var lblOptionName: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
