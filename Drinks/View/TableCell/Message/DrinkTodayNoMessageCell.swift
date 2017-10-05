//
//  DrinkTodayNoMessageCell.swift
//  Drinks
//
//  Created by maninder on 9/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class DrinkTodayNoMessageCell: UITableViewCell {

    var thread : ChatThread!
    
    
    @IBOutlet weak var lblGroupTag: UILabel!
    @IBOutlet weak var lblLocationDistance: UILabel!
    @IBOutlet weak var lblNoOfPersons: UILabel!
    @IBOutlet weak var imgvwGroup: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblGroupTag.cornerRadius(value : 10)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func assignCellData(thread :  ChatThread)
    {
        self.thread = thread
        
        let group = self.thread.group
        
        imgvwGroup.sd_setImage(with: URL(string: (group?.imageURL)!), placeholderImage: nil)
        setNoOfMembers(groups: (group?.groupConditions)! , label: lblNoOfPersons, relation: (group?.relationship)!)
        lblLocationDistance.text = group?.location?.LocationName
        setGroupTag(boolTag: (group?.tagEnabled)! , label: lblGroupTag)
        
    }

    
}
