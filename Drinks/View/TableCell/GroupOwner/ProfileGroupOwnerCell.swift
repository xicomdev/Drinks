//
//  ProfileGroupOwnerCell.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ProfileGroupOwnerCell: UITableViewCell {
    
    @IBOutlet var imgViewCover: UIImageView!
    var user : User!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var imgViewOwner: UIImageView!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgViewOwner.cornerRadius(value: imgViewOwner.frame.size.width/2)
        lblTag.cornerRadius(value:10)
//        lblTag.text = NSLocalizedString("My Treat", comment: "")
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
    
    
    func assignUserInfo(user : User)
    {
       
        self.user = user
        
       lblOwnerName.text  = self.user.fullName + " (\(self.user.age))"
        if Locale.preferredLanguages[0].contains("en") {
            lblOccupation.text  = self.user.job.engName
        }else {
            lblOccupation.text  = self.user.job.japName
        }
        userImage(imageView: imgViewOwner, user: user)
        userImage(imageView: imgViewCover, user: user)

    }
    
    
    
}
