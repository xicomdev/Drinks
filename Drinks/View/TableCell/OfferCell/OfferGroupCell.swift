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

    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgViewCreator: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgViewGroup: UIImageView!

    @IBOutlet weak var lblNoOfPeople: UILabel!
    
    @IBOutlet weak var btnInterested: UIButton!
    
   
    
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
        imgViewGroup.sd_setImage(with: urlFinalGroup, placeholderImage: nil)
        imgViewCreator.sd_setImage(with: urlFinalOwner, placeholderImage: nil)
        let strInfo = groupInfo.groupOwner.age.description + " / " + groupInfo.groupOwner.job.engName
        lblCreatorAge.text = strInfo
        lblLocation.text = groupInfo.location?.LocationName!
        
        if groupInfo.tagEnabled == true{
            lblTag.isHidden = false
        }else{
            lblTag.isHidden = true
        }
        
        if groupInfo.drinkedStatus == .Drinked{
            btnInterested.isSelected = true
        }else{
            btnInterested.isSelected = false
        }
        
        if groupInfo.groupBy == .Other
        {
            btnInterested.isHidden = false
        }else{
            //My Own Group
            btnInterested.isHidden = true
        }
        
         setNoOfMembers(groups: group.groupConditions, label: self.lblNoOfPeople)
    }

    
    
    
    
}
