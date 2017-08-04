//
//  MSImage.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MSImage: NSObject {

    
    var file : UIImage!
    var name : String!
    var filename : String!
    var mimeType : String!
    
    init(file: UIImage, variableName name: String, fileName filename: String, andMimeType mimeType: String){
        self.file = file
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }

}
