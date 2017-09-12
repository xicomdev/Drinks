//
//  Utility.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit

typealias ActionSheetHandler = ((_ Action: Bool, _ Index: Int) -> Void) // false for Cancel
typealias AlertHandler = ( (_ Index: Int) -> Void) // false for Cancel


@objc protocol MSSelectionCallback {
    @objc optional func moveWithSelection(selected : Any)
    @objc optional func actionPreviousVC(action: Bool )
    @objc optional func replaceRecords(obj : Any )
    @objc optional func replaceRecords()

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

public func showAlertWithAnimation(object : UIViewController){
    UIView.animate(withDuration: 0.3) {
        object.view.alpha = 1
    }
}

public func hideAlertWithAnimation(object : UIViewController , callBack:@escaping (_: Bool) -> ()){
    UIView.animate(withDuration: 0.3, animations: {
       // object.view.alpha = 0
    }) { (test) in
        callBack(true)
    }
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


func  showAlert(title : String , message : String , controller : UIViewController , handler : @escaping AlertHandler)
{
    let objAlertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
    let objAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:
        {Void in
            handler(0)
    })
    objAlertController.addAction(objAction)
    controller.present(objAlertController, animated: true, completion: nil)
}


func JSONString (paraObject : Any) -> String{
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



func actionSheet(btnArray : [String] , cancel : Bool , destructive : Int  ,  controller : UIViewController , handler : @escaping ActionSheetHandler)
{
    
    let actionSheetController: UIAlertController = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
    for  i in 0 ..< btnArray.count {
        
        
        if i == destructive{
            
            let actionNew : UIAlertAction = UIAlertAction(title: btnArray[i] , style: .destructive) { action -> Void in
                
                let title: String =  action.title!
                let index: Int = btnArray.index(of: title)!
                handler(true, index)
            }
            actionSheetController.addAction(actionNew)
            
        }else{
            
            let actionNew : UIAlertAction = UIAlertAction(title: btnArray[i] , style: .default) { action -> Void in
                
                let title: String =  action.title!
                let index: Int = btnArray.index(of: title)!
                handler(true, index)
            }
            actionSheetController.addAction(actionNew)
        }
       
    }
    
    if cancel == true{
        
        let actionNew: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            handler(false, -1)
        }
        actionSheetController.addAction(actionNew)
    }
    
    controller.present(actionSheetController, animated: true, completion: nil)
}


public func resizeImage(image: UIImage, size: CGSize) -> UIImage?
{
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

func getStringToDisplay(array : [Any] ,  type : FilterListing ) -> String
{
    var strToDisplay = ""
    
    if array.count > 0 {
        if type == .Age{
            
            if array.count > 0 {
                let arrayNew = array as! [String]
                strToDisplay = arrayNew.joined(separator: ",")
            }
        }else if type == .Job{
            let arrayNew = array as! [Job]
            let stringArray = arrayNew.flatMap { String($0.engName) }
            strToDisplay = stringArray.joined(separator: ",")
        }else if type == .Relation
        {
            let arrayNew = array as! [String]
            strToDisplay = arrayNew.joined(separator: ",")
            
        }else if type == .NumberOfPeople{
            let arrayNew = array as! [Int]
            
            let stringArray = arrayNew.flatMap { String($0) }
            strToDisplay =  stringArray.joined(separator: ",")
        }
    }
    
    return strToDisplay
}




func setNoOfMembers(groups :[ GroupCondition] , label : UILabel) {
    if groups.count > 1
    {
        label.text = (groups.count).description + " Members"
        
    }else{
     label.text = "1 Member"
    }
}


func setGroupTag(boolTag : Bool , label : UILabel) {
    label.isHidden = !boolTag
//    if groups.count > 1
//    {
//        label.text = (groups.count).description + " Members"
//        
//    }else{
//        label.text = "1 Member"
//    }
}


func userImage(imageView : UIImageView  , user : User)
{
    let urlFinalOwner = URL(string: user.imageURL)
    imageView.sd_setImage(with: urlFinalOwner, placeholderImage: nil)
    
}

func showInterestedAlert(controller : UIViewController){
    let reportAlertVC = mainStoryBoard.instantiateViewController(withIdentifier: "InterestedVC") as! InterestedVC
    reportAlertVC.view.alpha = 0
    controller.present(reportAlertVC, animated: false, completion: nil)
}




