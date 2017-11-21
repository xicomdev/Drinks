//
//  OfferGroupCell.swift
//  Drinks
//
//  Created by maninder on 9/1/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class OfferGroupCell: UITableViewCell {
    
    var callbackAction : ((Group )-> Void)? = nil
    var group : Group!

    @IBOutlet var lblCommentInfo: UILabel!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgViewCreator: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgViewGroup: UIImageView!

    @IBOutlet weak var lblNoOfPeople: UILabel!
    
    
   
    
    @IBOutlet weak var lblCreatorAge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTag.cornerRadius(value: 10)
        imgViewCreator.cornerRadius(value: 20)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func actionBtnInterestPressed(_ sender: Any) {
        if callbackAction != nil
        {
            self.callbackAction!(group!)
            
        }

        
    }
    
    func assignData(groupInfo : Group){
        self.group = groupInfo
        
        let urlFinalGroup = URL(string: groupInfo.imageURL)
        let urlFinalOwner = URL(string: groupInfo.groupOwner.imageURL)
        imgViewGroup.sd_setImage(with: urlFinalGroup, placeholderImage: GroupPlaceHolder)
        imgViewCreator.sd_setImage(with: urlFinalOwner, placeholderImage: userPlaceHolder)
        let strInfo = "\(groupInfo.groupOwner.age)" + " / " + groupInfo.groupOwner.job.engName
        lblCreatorAge.text = strInfo
        lblLocation.text = groupInfo.location?.LocationName!
        
        if groupInfo.tagEnabled == true
        {
            lblTag.isHidden = false
        }else{
            lblTag.isHidden = true
        }
        
       btnInterest.isUserInteractionEnabled = true
        
        if groupInfo.groupBy == .Other
        {
            
            setBiggerDrinkedStatus(btnStatus: btnInterest, status: groupInfo.drinkedStatus , fromScreen:"Offer")

        }else{
            //My Own Group
        }
         setNoOfMembers(groups: group.groupConditions, label: self.lblNoOfPeople, relation: group.relationship)
        
        lblInfo.text = self.group.groupOwner.lastLogin
        lblCommentInfo.text = self.group.groupDescription
    }

    
    
    
    
}
