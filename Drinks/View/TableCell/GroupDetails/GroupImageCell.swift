//
//  GroupImageCell.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupImageCell: UITableViewCell {

    
    var group : Group? = nil
    @IBOutlet weak var lblTag: UILabel!
    var callBackVC: ((GroupAction , Any?)-> Void)? = nil

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
            callBackVC!(.BACK , "Skip")
        }
        else if sender ==  btnOption
        {
            
            
            if let imageGroup = imgViewGroup.image
            {
                callBackVC!(.OPTION , imageGroup)
            }
            else{
                callBackVC!(.OPTION , "Skip")
            }
        }else if  sender ==  btnAccept
        {
            callBackVC!(.ACCEPT , "Skip")

        }
    }
    
    
    func setCellInfo(groupDetail : Group)
    {
        group = groupDetail
        
        if group != nil
        {
            let urlFinalGroup = URL(string: (group?.imageURL)!)
            imgViewGroup.sd_setImage(with: urlFinalGroup, placeholderImage: GroupPlaceHolder)
            
            self.lblTag.isHidden = true
            if group?.tagEnabled == true{
                self.lblTag.isHidden = false
            }
            if group?.groupBy == .Other
            {
                btnAccept.isHidden = false
                
            }else{
                //My Own Group
                btnAccept.isHidden = true
            }
            setBiggerDrinkedStatus(btnStatus: btnAccept, status: (group?.drinkedStatus)! , fromScreen: "Home")
        }
    }
    
}
