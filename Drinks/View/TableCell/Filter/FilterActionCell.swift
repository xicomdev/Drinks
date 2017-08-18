//
//  FilterActionCell.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class FilterActionCell: UITableViewCell {

    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.cornerRadius(value: 21)
        btnFilter.cornerRadius(value: 21)
        btnCancel.addBorderWithColorAndLineWidth(color: .darkGray, borderWidth: 0.5)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        
        
    }
    
    
    
    
}
