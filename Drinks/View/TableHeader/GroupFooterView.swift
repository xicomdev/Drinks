//
//  GroupFooterView.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupFooterView: UITableViewHeaderFooterView {

    
    
    
    class func instanceFromNib(width : CGFloat , height : CGFloat) -> GroupFooterView {
        let viewFromNib: GroupFooterView = Bundle.main.loadNibNamed("GroupFooterView",
                                                                     owner: nil,
                                                                     options: nil)?.first as! GroupFooterView
        viewFromNib.frame.size = CGSize(width: width, height: height)
        return  viewFromNib
        
    }

    
    
    var callbackDone : ((GroupAction)-> Void)? = nil

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtRelationship: UITextField!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    
    
    @IBAction func actionBtnSubmitPressed(_ sender: Any) {
        self.callbackDone!(.DONE)
    }
    

}
