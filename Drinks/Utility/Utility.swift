//
//  Utility.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit


@objc protocol MSSelectionCallback {
    @objc optional func moveWithSelection(selected : Any)
    @objc optional func actionPreviousVC(action: Bool )
    @objc optional func replaceRecords(obj : AnyObject )
    @objc optional func moveRecordsWithType(obj : AnyObject , type : String )

    
}


func FontBold(size: CGFloat) -> (UIFont)
{
    return UIFont.boldSystemFont(ofSize: size)
}

func FontRegular(size: CGFloat) -> (UIFont)
{
    return UIFont.systemFont(ofSize: size)
}

func FontLight(size: CGFloat) -> (UIFont)
{
    
    return UIFont.systemFont(ofSize: size)
}


func  showAlert(title : String , message : String , controller : UIViewController)
{
    let objAlertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
    let objAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:
        {Void in
            
    })
    objAlertController.addAction(objAction)
    controller.present(objAlertController, animated: true, completion: nil)
}
