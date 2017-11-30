//
//  UserMessageCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class HistoryMsgCell: UITableViewCell {

    var thread : ChatThread!

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblAgeOccupation: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
   
    @IBOutlet weak var imgVwUser: SetCornerImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignCellData(thread :  ChatThread)
    {
        self.thread = thread
        
        let lastMessageUser = thread.lastMessage?.senderUser
        
        lbUserName.text = (lastMessageUser?.fullName)! + " " + (lastMessageUser?.age.description)!
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
