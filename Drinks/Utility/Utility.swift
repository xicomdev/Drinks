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


func JSONString (paraObject : AnyObject) -> String{
    var strReturning = String()
    do
    {
        if let postData : NSData = try JSONSerialization.data(withJSONObject: paraObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        {
            strReturning  = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        }
    }
    catch
    {
        print(error)
    }
    return strReturning
}





public func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
    var returnImage: UIImage?
    var scaleFactor: CGFloat = 1.0
    var scaledWidth = size.width
    var scaledHeight = size.height
    var thumbnailPoint = CGPoint(x: 0, y: 0)
    
    if !image.size.equalTo(size) {
        let widthFactor = size.width / image.size.width
        let heightFactor = size.height / image.size.height
        
        if widthFactor > heightFactor {
            scaleFactor = widthFactor
        } else {
            scaleFactor = heightFactor
        }
        
        scaledWidth = image.size.width * scaleFactor
        scaledHeight = image.size.height * scaleFactor
        
        if widthFactor > heightFactor {
            thumbnailPoint.y = (size.height - scaledHeight) * 0.5
        } else if widthFactor < heightFactor {
            thumbnailPoint.x = (size.width - scaledWidth) * 0.5
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    
    var thumbnailRect = CGRect.zero
    thumbnailRect.origin = thumbnailPoint
    thumbnailRect.size.width = scaledWidth
    thumbnailRect.size.height = scaledHeight
    
    image.draw(in: thumbnailRect)
    returnImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    
    return returnImage
}



