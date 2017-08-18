//
//  ProfileGroupOwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ProfileGroupOwnerCell: UITableViewCell {

    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgViewOwner: UIImageView!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgViewOwner.cornerRadius(value: imgViewOwner.frame.size.width/2)
        lblTag.cornerRadius(value:10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCornerRadius()
    {
        imgViewOwner.cornerRadius(value: (ScreenWidth/3)/2)
        
    }
    
    
    
}
