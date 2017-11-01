//
//  MSExtensions.swift
//  iCheckbook
//
//  Created by maninder on 27/02/17.
//  Copyright © 2017 maninder. All rights reserved.
//

import Foundation
import UIKit



var dateFormate : DateFormatter = DateFormatter()
let APP_DateFormat = "dd-MMM-yyyy"
let APP_DateFormatNew = "yyyy-mm-dd"

let APP_DateMessageFormat = "dd/MM/yyyy hh:mm a"





@objc protocol MSProtocolCallback {
    
    @objc optional func actionMoveToPreviousVC( )
    @objc optional func actionBackDismiss( )
    @objc optional func actionMovingWithData(objData : AnyObject)
    @objc optional func actionMoveToPreviousVC(objAny : AnyObject )

    @objc optional func actionMoveToPreviousVC(action: Bool )
    @objc optional func actionMoveWithObj(obj : AnyObject , test : Bool )
    @objc optional func replaceGroup(obj : Any )
    @objc optional func updateData()


    
}

func appDelegate() ->  AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}

extension UIButton {
    func underlineButton(text: String , font : UIFont) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        //  NSFontAttributeName : FontLight(size: 15)
        titleString.addAttribute(NSFontAttributeName , value: font , range: NSMakeRange(0, text.characters.count))
        
        self.setAttributedTitle(titleString, for: .normal)
    }
}
extension NSObject{
    
    //MARK: ------ Popular Objects
    
    var timeStamp: String{
        let time = String(format: "%0.0f", Date().timeIntervalSince1970 * 1000)
        return time
    }
    public func setMessageDate()-> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = APP_DateMessageFormat
        return formatter.string(from: Date())
        
    }
    
        
        
        //MARK: ------ Popular Objects
        var ScreenHeight: CGFloat{
            return UIScreen.main.bounds.size.height //UIScreen.main.bounds.size.height
        }
        var ScreenWidth: CGFloat{
            return UIScreen.main.bounds.size.width
        }
        
    
}




extension Double {
    
    
    func roundTo(places: Double) -> Double {
        let divisor = pow(10.0, places)
        return (self * divisor).rounded() / divisor
    }
}



extension Date {
    
    
    public func  toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        return timeString
    }
    
    
    public static func timestamp() -> String {
        return "\(Date().timeIntervalSince1970 * 1000)" as String
    }
    
    public func getMessageDate()-> Date{
        return Date()
    }
    
}

 extension NSDate {
   
    public func getStringFromDate() -> String
    {
       dateFormate.dateFormat = APP_DateFormat
        let dateString = dateFormate.string(from: self as Date)
        return dateString
    }
}

extension String
{
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func getNumberString() -> String{
        var strLocal = self
        strLocal = strLocal.removeParticularCharacterString(character: "-")
        strLocal = strLocal.removeParticularCharacterString(character: ".")
        return strLocal
    }
    
    func getDoubleString() -> String{
        
        var strLocal = self
        strLocal = strLocal.removeParticularCharacterString(character: "-")
        return strLocal
    }
    
    func getDoubleValue() -> Double{
        
        var strLocal = self
        strLocal = strLocal.removeParticularCharacterString(character: "-")
        return Double(strLocal)!
        
    }
    
    public func getDateFromString() -> Date
    {
        dateFormate.dateFormat = APP_DateFormat
        return dateFormate.date(from: self)!
    }
    
    public func getTimeFromDate () -> String {
        let formattr = DateFormatter()
        formattr.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = formattr.date(from: self)
        formattr.dateFormat = "hh:mm a"
        if dt != nil {
            return formattr.string(from: dt!)
        }else {
            return self
        }
    }
    
    
  public  func getAgeFromDOB() -> Int
    {
        let userDOB = dateFormatter.date(from: self)!
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let ageComponent = gregorian.components(.year, from: userDOB , to: Date(), options: [])
        return ageComponent.year!
    }

    
    
     public func isValidEmail() ->Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }

    
    public func removeSpacesInString() -> String
    {
       return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    

    public func getNumberFromString()-> Double
    {
        let newSTR = self.removeParticularCharacterString(character: ",")
        if let number = Int(newSTR) {
            return Double(number)
        }
        return 0.0
    }

    
    public func removeParticularCharacterString(character: String) -> String
    {
        return self.replacingOccurrences(of: character, with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    public func removeMultipleCharactersString(arrayMutliple : [String]) -> String
    {
        var newString = self
        for item in arrayMutliple{
            newString =  newString.replacingOccurrences(of: item, with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return newString
    }


    public func isStringEmpty() -> Bool
    {
        let testingString = self
        if testingString.characters.count == 0 || checkIsEmpty()
        {
            return true
        }
        return false
    }
    
    func checkIsEmpty()-> Bool{
        let trimmedString = self.trimmingCharacters(in:  CharacterSet.whitespaces)
        if trimmedString.characters.count == 0 {
            return true
        }else{
            return false
        }
    }
    
    func removeEndingSpaces() -> String
    {
        let strTrimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strTrimmed
    }
}

extension UIView
{
    public func cornerRadius(value: CGFloat){
        let view:UIView = self
        view.layer.cornerRadius = value;
        view.clipsToBounds = true
    }

    
    
    public func addBorderWithColorAndLineWidth(color: UIColor , borderWidth : Float){
        let view:UIView = self
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = CGFloat(borderWidth)
    }

}



extension UIViewController
{
    public func navTitle(title:NSString,color:UIColor,font:UIFont){
        let label: UILabel = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = title as String
        label.font = font
        label.textAlignment = NSTextAlignment.center
        label.isUserInteractionEnabled = true;
        label.textColor = color
        self.navigationItem.titleView = label
        label.sizeToFit()
    }
    
    
    public func presentControllerWithNavController(objNextVC: UIViewController)
    {
        let navigation = UINavigationController(rootViewController: objNextVC)
        navigation.isNavigationBarHidden = true
        self.navigationController?.present(navigation, animated: true, completion: nil)
    }
    
}

extension UITextField{
    
    public func acceptOnly15CharactersOnly(strNew: String)-> Bool
    {
        let txtFPara : UITextField = self
        if strNew == ""
        {
            return true
        }else if txtFPara.text?.characters.count == 15 {
            return false
        }
        return true
    }
    
    
    public func setDollarSign(){
        
        let view :UITextField = self
        let leftView : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: view.frame.size.height))
        leftView.backgroundColor = UIColor.clear
        leftView.text = "$";
        leftView.font = FontLight(size: 15)
        leftView.textAlignment = NSTextAlignment.center;
        view.leftView = leftView
        view.leftViewMode = .always
        view.contentVerticalAlignment = .center
    }
}


extension UITableView{
    public func registerNibsForCells(arryNib : NSArray)
    {
        for i in 0  ..< arryNib.count
        {
            let nibName = arryNib.object(at: i) as! String
            print(nibName)
            let nibCell = UINib.init(nibName:nibName, bundle: nil);
            self.register(nibCell, forCellReuseIdentifier:nibName)
        }
    }
}

