//
//  GroupOwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupOwnerCell: UITableViewCell {

    @IBOutlet weak var btnFriendsCount: UIButton!
    @IBOutlet weak var btnOffersCount: UIButton!
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
        var strInfo = ""
        if Locale.preferredLanguages[0].contains("en") {
            strInfo = groupInfo.groupOwner.fullName + "(\(groupInfo.groupOwner.age))" + " / " + groupInfo.groupOwner.job.engName
        }else {
            strInfo = groupInfo.groupOwner.fullName + "(\(groupInfo.groupOwner.age))" + " / " + groupInfo.groupOwner.job.japName
        }
        btnOffersCount.setTitle(groupInfo.groupOwner.offersCount, for: .normal)
        btnFriendsCount.setTitle(groupInfo.groupOwner.fbFriendsCount, for: .normal)
        lblGroupOwner.text = strInfo
        
    }
    
}
