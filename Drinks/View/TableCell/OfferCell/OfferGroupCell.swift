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
    
}
