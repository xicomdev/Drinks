//
//  GroupImageCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupImageCell: UITableViewCell {

    
    @IBOutlet weak var lblTag: UILabel!
    var callbackAction : ((GroupAction)-> Void)? = nil

    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var imgViewGroup: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTag.cornerRadius(value: 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        
        if sender == btnBack
        {
            callbackAction!(.BACK)
        }
        else if sender ==  btnOption
        {
            callbackAction!(.OPTION)
        }else
        {
            callbackAction!(.ACCEPT)
        }
    }
    
}
