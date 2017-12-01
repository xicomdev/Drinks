//
//  InfoCell.swift
//  Drinks
//
//  Created by maninder on 8/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet var lblRelation: UILabel!
    @IBOutlet weak var lblLowerInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRelation.text = NSLocalizedString("Creator Info", comment: "")
        lblLowerInfo.text = NSLocalizedString("Select group options for friends to be invited with age groups and occupations.", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showTopLabel()
    {
        lblLowerInfo.isHidden = true
        
    }
    
}
