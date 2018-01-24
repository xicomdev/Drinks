//
//  GroupCell.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    @IBOutlet var lblGroupComment: UILabel!
    
    
    @IBOutlet var lblLastLogin: UILabel!
    var callbackAction : ((Group )-> Void)? = nil

    @IBOutlet weak var imgAccepted: UIImageView!
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
        lblTag.text = NSLocalizedString("My Treat", comment: "")

        // Initialization code
    }

    
    
    func assignData(groupInfo : Group){
        self.group = groupInfo
        
        
        imgViewGroup.sd_setImage(with: URL(string: groupInfo.imageURL), placeholderImage: GroupPlaceHolder)
        imgViewCreator.sd_setImage(with: URL(string: groupInfo.groupOwner.imageURL), placeholderImage: userPlaceHolder)
        var strInfo = ""

        if Locale.preferredLanguages[0].contains("en") {
            strInfo = groupInfo.groupOwner.age.description + " / " + groupInfo.groupOwner.job.engName
        }else {
            strInfo = groupInfo.groupOwner.age.description + " / " + groupInfo.groupOwner.job.japName
        }
        lblOwnerInfo.text = strInfo
        
        lblLastLogin.text = groupInfo.groupOwner.lastLogin.getTimeFromDate()
        
        lblLocationName.text = groupInfo.location?.LocationName!
        
        if groupInfo.tagEnabled == true{
            lblTag.isHidden = false

        }else{
            lblTag.isHidden = true
        }
        
        lblGroupComment.text = groupInfo.groupDescription
        
        if groupInfo.groupBy == .Other
        {
            setSmallDrinkedStatus(btnStatus: btnInterested,imgAccepted: imgAccepted, status: groupInfo.drinkedStatus )
        }else{
          
            btnInterested.isHidden = true
            imgAccepted.isHidden = true
        }

        setNoOfMembers(groups: group.groupConditions, label: self.lblNoOfConditions, relation:group.relationship)
    }
    
    @IBAction func actionBtnDrinked(_ sender: UIButton) {
        if callbackAction != nil
        {
            self.callbackAction!(group!)
            
         }
    }
}
