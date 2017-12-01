//
//  LocationCell.swift
//  Drinks
//
//  Created by maninder on 8/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    
    var callbackAction : ((GroupAction )-> Void)? = nil

    
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblTagName: UILabel!

    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnSelection: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnRefresh.cornerRadius(value: 18)
        btnRefresh.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)
        lblTagName.text = NSLocalizedString("I will treat you.", comment: "")
        btnRefresh.setTitle(NSLocalizedString("Refresh", comment: ""), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func actionBtnSelectionPressed(_ sender: UIButton)
    {
        if sender == btnRefresh{
            self.callbackAction!(.LOCATION )
        }else {
            btnSelection.isSelected = !btnSelection.isSelected
            self.callbackAction!(.TAG)
        }
        
    }
}
