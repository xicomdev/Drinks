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
    @objc optional func moveHomeToAddNew()
    @objc optional func gotoHome()

}

protocol FilterCallback {
    func moveWithSelectionFilter(filterInfo : FilterInfo, sortInfo: SortInfo)
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

func getMessageTime(timestamp: Double) -> String{
    
    let current = Date()
    let endTime = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    if dateFormatter.string(from: endTime) != dateFormatter.string(from: current) {
        return dateFormatter.string(from: endTime)
    }else {
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: endTime)
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
        
        let actionNew: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            handler(false, -1)
        }
        actionSheetController.addAction(actionNew)
    }
    
    controller.present(actionSheetController, animated: true, completion: nil)
}



func MSAlert( message : String , firstBtn : String , SecondBtn : String  ,  controller : UIViewController , handler : @escaping ActionSheetHandler)
{
    
    
    let alertController = UIAlertController(title: "Drinks", message: message, preferredStyle: UIAlertControllerStyle.alert)
    let actionLeft : UIAlertAction = UIAlertAction(title: firstBtn , style: .default) { action -> Void in
                        handler(true, 0)
            }
      alertController.addAction(actionLeft)
    let actionRight : UIAlertAction = UIAlertAction(title: SecondBtn , style: .default) { action -> Void in
        handler(true, 1)
    }
    alertController.addAction(actionRight)
        controller.present(alertController, animated: true, completion: nil)

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






func getOutOfApp(){
    
    SwiftLoader.hide()
     appDelegate().timerMessage.invalidate()
        appDelegate().currentThread  = nil
    LoginManager.sharedInstance.removeUserProfile()
    FBManager.sharedInstance.logout()
    let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
    let naviagtionController = UINavigationController(rootViewController: loginVC)
    naviagtionController.isNavigationBarHidden = true
    appDelegate().window?.rootViewController = naviagtionController
}




func deviceUniqueIdentifier() -> String {
    
    let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    var strApplicationUUID = SSKeychain.password(forService: appName, account: "incoding")
    if (strApplicationUUID == nil)
    {
        strApplicationUUID = UIDevice.current.identifierForVendor?.uuidString;
        SSKeychain.setPassword(strApplicationUUID, forService: appName, account: "incoding")
    }
    
    return strApplicationUUID!;
    
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
            var stringArray = [String]()
            if Locale.preferredLanguages[0].contains("en") {
                stringArray = arrayNew.flatMap { String($0.engName) }
            }else {
                stringArray = arrayNew.flatMap { String($0.japName) }
            }
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




func setNoOfMembers(groups :[ GroupCondition] , label : UILabel, relation:String) {
    var relationship = ""
    if relation != "" {
        relationship = "(\(relation))"
    }
    if groups.count > 1
    {
        label.text = (groups.count + 1).description + " \(relationship)"
        
    }else if groups.count == 1 {
        if groups[0].age == 0 && groups[0].occupation.engName == "" {
            label.text = "1 \(relationship)"
        }else {
            label.text = "2 \(relationship)"
        }
    }else{
        label.text = "1 \(relationship)"
    }
}


func setSmallDrinkedStatus(btnStatus : UIButton , status : DrinkStatus)
{
//    case Drinked = "drinked"
//    case NotDrinked = "undrinked"
//    case Waiting = "waiting"
//    case Confirmed = "confirmed"
    switch status
    {
    case .Matched , .Drinked:
        
        
        btnStatus.setImage( UIImage(named: "Accepted"), for: .normal)
        btnStatus.isUserInteractionEnabled = false
        break
        
    case .NotDrinked :
        btnStatus.setImage( UIImage(named: "Accept"), for: .normal)
        btnStatus.isUserInteractionEnabled = true

        break
        
        
   
//    case .Drinked :
//        btnStatus.setImage( UIImage(named: "Accepted") , for: .normal)
//          btnStatus.isUserInteractionEnabled = false
//        break
        
    }
}


func setBiggerDrinkedStatus(btnStatus : UIButton , status : DrinkStatus, fromScreen:String)
{
  
    switch status
    {
       
    case .Matched , .Drinked :
        if fromScreen == "Home" {
            btnStatus.setImage( UIImage(named: "Accepted"), for: .normal)
        }else {
            btnStatus.setImage( UIImage(named: "OfferAccepted"), for: .normal)
        }
        btnStatus.isUserInteractionEnabled = false
        break
        
    case .NotDrinked :
        if fromScreen == "Home" {
            btnStatus.setImage( UIImage(named: "Accept"), for: .normal)
        }else {
            btnStatus.setImage( UIImage(named: "OfferAccept"), for: .normal)
        }
        btnStatus.isUserInteractionEnabled = true
        break
        
   
//    case .Drinked :
//        btnStatus.setImage( UIImage(named: "OfferAccepted") , for: .normal)
//        btnStatus.isUserInteractionEnabled = false
//
//        break
//    }
    }
    
}



func setGroupTag(boolTag : Bool , label : UILabel) {
    label.isHidden = !boolTag
}




func userImage(imageView : UIImageView  , user : User)
{
    let urlFinalOwner = URL(string: user.imageURL)
    imageView.sd_setImage(with: urlFinalOwner, placeholderImage: userPlaceHolder)
    
}

func showInterestedAlert(controller : UIViewController){
    let reportAlertVC = mainStoryBoard.instantiateViewController(withIdentifier: "InterestedVC") as! InterestedVC
    reportAlertVC.view.alpha = 0
    controller.present(reportAlertVC, animated: false, completion: nil)
}




