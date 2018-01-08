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
        if LoginManager.getMe.DOB == "" {
            lblName.text = LoginManager.getMe.fullName
        }else {
            lblName.text = LoginManager.getMe.fullName + " (\(LoginManager.getMe.DOB.getAgeFromDOB()))"
        }
        if Locale.preferredLanguages[0].contains("en") {
            lblOccupation.text = LoginManager.getMe.job.engName
        }else {
            lblOccupation.text = LoginManager.getMe.job.japName
        }
        imgViewOwner.sd_setImage(with: URL(string : LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)
        
    }
    
}
