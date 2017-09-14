//
//  MyGroupsHeader.swift
//  Drinks
//
//  Created by maninder on 9/13/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MyGroupsHeader: UICollectionReusableView {
    
    
    
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var lblCounter: UILabel!
    var callbackBtn : (()-> Void)? = nil
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    @IBAction func actionBtnMyGroups(_ sender: UIButton) {
        if callbackBtn != nil{
            self.callbackBtn!()
            
        }
    }

}
