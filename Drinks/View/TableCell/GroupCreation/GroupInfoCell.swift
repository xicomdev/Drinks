//
//  GroupInfoCell.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit



enum GroupAction : String{
     case SELECT = "SELECT"
    case CHANGE = "CHANGE"
    case LOCATION = "LOCATION"
    case TAG = "TAG"
    case AGE = "AGE"
    case OCCUPATION = "OCCUPATION"
    case DELETE = "DELETE"
    case DONE = "DONE"
    case ADDMORE = "ADDMORE"
      case BACK = "BACK"
      case OPTION = "OPTION"
    case ACCEPT = "ACCEPT"
    case FILTER = "FILTER"
    case CANCEL = "CANCEL"


    
}

class GroupInfoCell: UITableViewCell {
    
    
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var lblJobBorder: UILabel!
    
    @IBOutlet weak var lblOccupationBorder: UILabel!
    
    var conditionCount : Int = 0
    var groupCond : GroupCondition =  GroupCondition()
    var callbackAction : ((GroupAction , Any?)-> Void)? = nil
    
    @IBOutlet weak var btnSelectAge: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelectOccupation: UIButton!
    @IBOutlet weak var lblOccupationSelected: UILabel!
    @IBOutlet weak var lblAgeSelected: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCounter.cornerRadius(value: 15)
        lblCounter.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)
         lblJobBorder.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)
         lblOccupationBorder.addBorderWithColorAndLineWidth(color: UIColor.gray, borderWidth: 0.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        if sender == btnCancel
        {
            self.callbackAction!(.DELETE , self)
            
        }else if sender == btnSelectAge
        {
            self.callbackAction!(.AGE , groupCond)

        }else if sender == btnSelectOccupation
        {
            self.callbackAction!(.OCCUPATION , groupCond)
        }
    }
    
    func setNewValues()
    {
        
        if groupCond.age != 0 {
            self.txtAge.text = groupCond.age.description

        }
         self.txtOccupation.text = groupCond.occupation.engName
    }
    
    
    
    
    
    
}
