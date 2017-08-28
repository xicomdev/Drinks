//
//  GroupCell.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet var viewOuter: UIView!
    @IBOutlet var lblTag: UILabel!
    @IBOutlet weak var lblNoOfConditions: UILabel!

    @IBOutlet weak var lblOwnerInfo: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var imgViewGroup: UIImageView!
    
    @IBOutlet weak var lblDistance: UILabel!
    var group : Group!
    @IBOutlet var imgViewCreator: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOuter.cornerRadius(value: 5)
        lblTag.cornerRadius(value: 7.5)
        imgViewCreator.cornerRadius(value: 15)
        // Initialization code
    }

    
    
    func assignData(groupInfo : Group){
        self.group = groupInfo
        
        
        let urlFinalGroup = URL(string: groupInfo.imageURL)
         let urlFinalOwner = URL(string: groupInfo.groupOwner.imageURL)
        imgViewGroup.sd_setImage(with: urlFinalGroup, placeholderImage: nil)
        imgViewCreator.sd_setImage(with: urlFinalOwner, placeholderImage: nil)
        let strInfo = groupInfo.groupOwner.age.description + " / " + groupInfo.groupOwner.job.engName
        lblOwnerInfo.text = strInfo
        lblLocationName.text = groupInfo.location?.LocationName!
        
        if groupInfo.tagEnabled == true{
            lblTag.isHidden = false

        }else{
            lblTag.isHidden = true
        }
        
        
        lblNoOfConditions.text = group.groupConditions.count.description + " Members"
    }
}
