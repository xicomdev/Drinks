//
//  AddMoreCell.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class AddMoreCell: UITableViewCell {

    
      var callbackAddMore : ((GroupAction)-> Void)? = nil
    @IBOutlet weak var btnAddMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionBtnAddMore(_ sender: UIButton) {
        self.callbackAddMore!(.ADDMORE )
    }
    
}
