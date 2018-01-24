//
//  GroupMessageCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class DrinkTodayCell: UITableViewCell {

    
    var thread : ChatThread!
    
    
    @IBOutlet weak var lblGroupTag: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAgeOccupation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
 
    @IBOutlet weak var imgVwUser: SetCornerImageView!
    @IBOutlet weak var lblLocationDistance: UILabel!
    @IBOutlet weak var lblNoOfPersons: UILabel!
    @IBOutlet weak var imgvwGroup: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblGroupTag.cornerRadius(value : 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func assignCellData(thread :  ChatThread)
    {
        self.thread = thread
        
    let group = self.thread.group
        
        if group?.imageURL != nil {
            imgvwGroup.sd_setImage(with: URL(string: (group?.imageURL)!), placeholderImage: nil)
            setNoOfMembers(groups: (group?.groupConditions)! , label: lblNoOfPersons, relation: (group?.relationship)!)
            let firstLoc = group?.location?.LocationName!.components(separatedBy: ",").first
            lblLocationDistance.text = firstLoc! + " (\(NSNumber(value: (group?.distance)!))km)"
            setGroupTag(boolTag: (group?.tagEnabled)! , label: lblGroupTag)
            
            let lastMessageUser = thread.lastMessage?.senderUser
            
            lblUserName.text = (lastMessageUser?.fullName)! + " " + (lastMessageUser?.age.description)!
            if Locale.preferredLanguages[0].contains("en") {
                lblAgeOccupation.text = lastMessageUser?.job.engName
            }else {
                lblAgeOccupation.text = lastMessageUser?.job.japName
            }
            imgVwUser.sd_setImage(with: URL(string: lastMessageUser!.imageURL), placeholderImage: nil)
            lblMessage.text = self.thread.lastMessage!.message
            lblTime.text = getMessageTime(timestamp: (self.thread.lastMessage?.timestamp)!)
        }
    }

}
