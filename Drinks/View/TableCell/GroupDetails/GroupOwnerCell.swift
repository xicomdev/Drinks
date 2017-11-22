//
//  GroupOwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupOwnerCell: UITableViewCell {

    @IBOutlet weak var btnUserCount: UIButton!
    @IBOutlet weak var btnAcceptedCount: UIButton!
    @IBOutlet weak var lblGroupOwner: UILabel!
    
    var group : Group? = nil
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
    
    
    
    func assignData(groupInfo : Group){
        self.group = groupInfo
        
        
//        let urlFinalOwner = URL(string: groupInfo.groupOwner.imageURL)
//        imgViewOwner.sd_setImage(with: urlFinalOwner, placeholderImage: nil)
//        
        
        userImage(imageView: imgViewOwner, user: groupInfo.groupOwner)
        let strInfo = groupInfo.groupOwner.fullName + "(\(groupInfo.groupOwner.age))" + " / " + groupInfo.groupOwner.job.engName
        lblGroupOwner.text = strInfo
        
    }
    
}
