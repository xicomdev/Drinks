//
//  GroupCell.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    
    
    var callbackAction : ((Group )-> Void)? = nil

    @IBOutlet var viewOuter: UIView!
    @IBOutlet var lblTag: UILabel!
    @IBOutlet weak var lblNoOfConditions: UILabel!

    @IBOutlet weak var lblOwnerInfo: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var imgViewGroup: UIImageView!
    
    @IBOutlet weak var btnInterested: UIButton!
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
        
        
        imgViewGroup.sd_setImage(with: URL(string: groupInfo.imageURL), placeholderImage: nil)
        imgViewCreator.sd_setImage(with: URL(string: groupInfo.groupOwner.imageURL), placeholderImage: nil)
        let strInfo = groupInfo.groupOwner.age.description + " / " + groupInfo.groupOwner.job.engName
        lblOwnerInfo.text = strInfo
        lblLocationName.text = groupInfo.location?.LocationName!
        
        if groupInfo.tagEnabled == true{
            lblTag.isHidden = false

        }else{
            lblTag.isHidden = true
        }
        
        
        
        if groupInfo.groupBy == .Other
        {
            btnInterested.isHidden = false
            if groupInfo.drinkedStatus == .Drinked{
                btnInterested.isSelected = true
            }else{
                btnInterested.isSelected = false
            }
        }else{
            //My Own Group
            btnInterested.isHidden = true
            btnInterested.isSelected = false
        }

        setNoOfMembers(groups: group.groupConditions, label: self.lblNoOfConditions)
    }
    
    
    @IBAction func actionBtnDrinked(_ sender: UIButton) {
        if callbackAction != nil
        {
            self.callbackAction!(group!)
            
         }
       
    }
    
}
