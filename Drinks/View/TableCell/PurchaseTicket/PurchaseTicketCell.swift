//
//  PurchaseTicketCell.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/5/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PurchaseTicketCell: UITableViewCell {
    var callbackBuy : ((Ticket)-> Void)? = nil

    @IBOutlet weak var btnBuy: SetCornerButton!

    @IBAction func actionBtnBuy(_ sender: UIButton)
    {
        if callbackBuy != nil{
            self.callbackBuy!(ticket)
        }
    }
    
    var ticket : Ticket!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnBuy.setTitle(NSLocalizedString("Buy", comment: ""), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func assignMember(ticket : Ticket)
    {
        self.ticket = ticket
        lblPrice.text = "¥\(Int(ticket.amount))"
        if Locale.preferredLanguages[0].contains("en") {
            lblName.text = ticket.engName
        }else {
            lblName.text = ticket.japName
        }
        lblDiscount.isHidden = false
        lblDiscount.text = "¥ \(NSLocalizedString("discount!", comment: ""))"

    }
    
    
}
