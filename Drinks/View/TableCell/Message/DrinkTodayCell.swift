//
//  GroupMessageCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class DrinkTodayCell: UITableViewCell {

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
