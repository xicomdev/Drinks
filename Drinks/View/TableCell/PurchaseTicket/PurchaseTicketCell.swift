//
//  PurchaseTicketCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/5/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PurchaseTicketCell: UITableViewCell {
    var callbackBuy : (()-> Void)? = nil

    @IBOutlet weak var btnBuy: SetCornerButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionBtnBuy(_ sender: UIButton)
    {
            self.callbackBuy!()
    }
}
