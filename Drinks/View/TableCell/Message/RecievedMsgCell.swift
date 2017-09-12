//
//  RecievedMsgCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class RecievedMsgCell: UITableViewCell {

    
    var message : Message!

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgVwUser: SetCornerImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMessageDetails( msgInfo : Message)
    {
        message = msgInfo
        imgVwUser.sd_setImage(with: URL(string : msgInfo.senderUser.imageURL )   , placeholderImage: userPlaceHolder)
        lblMsg.text = message.message

    }
    
}
