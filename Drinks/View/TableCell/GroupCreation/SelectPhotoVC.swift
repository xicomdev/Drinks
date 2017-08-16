//
//  SelectPhotoVC.swift
//  Drinks
//
//  Created by maninder on 8/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class SelectPhotoVC: UITableViewCell {

    var callbackImage : ((GroupAction)-> Void)? = nil

    
    @IBOutlet weak var btnChangePhoto: UIButton!
    @IBOutlet weak var imgViewGroup: UIImageView!
    @IBOutlet weak var btnSelectPhoto: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnChangePhoto.cornerRadius(value: 22.5)
        btnChangePhoto.isHidden = true
        btnSelectPhoto.cornerRadius(value: 22.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func updateUI(btnCheck : Bool)
    {
        if btnCheck == true{
            btnChangePhoto.isHidden = false
            btnSelectPhoto.isHidden = true

        }else{
            
            btnChangePhoto.isHidden = true
            btnSelectPhoto.isHidden = false
        }
        
    }
    
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        
        if sender == btnSelectPhoto {
            callbackImage!(.SELECT)
        }else{
            callbackImage!(.CHANGE)
        }
        
    }
    
    
    
}
