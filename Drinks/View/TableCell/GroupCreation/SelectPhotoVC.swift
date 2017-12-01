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

    @IBOutlet weak var lbl1UploadPhoto: UILabel!
    @IBOutlet weak var lbl2UploadPhoto: UILabel!
    
    @IBOutlet weak var btnChangePhoto: UIButton!
    @IBOutlet weak var imgViewGroup: UIImageView!
    @IBOutlet weak var btnSelectPhoto: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnChangePhoto.cornerRadius(value: 22.5)
        btnChangePhoto.isHidden = true
        btnSelectPhoto.cornerRadius(value: 22.5)
        lbl2UploadPhoto.text = NSLocalizedString("If you do not set a photo,\nThe secretary's profile picture is displayed.", comment: "")
        lbl1UploadPhoto.text = NSLocalizedString("Posting self-portrait photos,\nMatching rate will rise", comment: "")
        btnChangePhoto.setTitle(NSLocalizedString("Change", comment: ""), for: .normal)
        btnSelectPhoto.setTitle(NSLocalizedString("Upload", comment: ""), for: .normal)
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
