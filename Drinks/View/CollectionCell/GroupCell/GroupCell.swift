//
//  GroupCell.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet var viewOuter: UIView!
    @IBOutlet var lblTag: UILabel!

    @IBOutlet var imgViewCreator: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOuter.cornerRadius(value: 5)
        lblTag.cornerRadius(value: 7.5)
        imgViewCreator.cornerRadius(value: 15)
        // Initialization code
    }

}
