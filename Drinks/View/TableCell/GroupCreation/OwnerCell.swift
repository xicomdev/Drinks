//
//  OwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class OwnerCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
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
    
    func setOwnerInfo(){
        
        lblName.text = LoginManager.getMe.fullName
        lblOccupation.text = LoginManager.getMe.job.engName
    
    }
    
}
