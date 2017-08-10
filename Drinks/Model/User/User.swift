//
//  User.swift

//
//  Created by maninder on 5/16/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit

enum Gender : String {
    
    case Male = "Male"
    case Female = "Female"
    
}


enum ProfileStatus : String
{
    
    case Pending = "Pending"
    case Active = "Active"
    
}

class User: NSObject,NSCoding
{
    var fullName : String!
    var firstName : String = ""
    var lastName : String = ""
    var emailAddress: String!
    var phoneNumber: String!
    var password : String!
     var ID: String!
    var sessionID : String!
    var socialID : String!
    var myCredits : Int = 0
    var otpCode : String = ""
    var job : Job = Job()
    var DOB : String = ""
    var bloodGroup : String = ""
    var relationship : String = ""
    var tabaco : String = ""
    var schoolCareer : String = ""
    var annualIncome : String = ""
    var imageURL : String = ""


    
    var myGender : Gender = .Male
    
    var profileStatus : ProfileStatus = .Pending
    
    
    override init()
    {
        ID = ""
        fullName = ""
        emailAddress = ""
        password  = ""
        phoneNumber  = ""
        sessionID = ""

        socialID = ""
    }
    
    convenience init(dict : Any) {
        self.init()
        guard let dictLocal = dict as? Dictionary<String, Any> else {
            return
        }
        
//        ID =  (dictLocal["id"] as! NSNumber).description
//        emailAddress = dictLocal["email_address"] as? String
//         let status = dictLocal["status"] as! String
//          profileStatus =   ProfileStatus(rawValue: status)!
//        print(profileStatus)
//        if profileStatus == .Active{
//            sessionID = dictLocal["session_id"] as! String
//        }
//        
//        if let firstName = dictLocal["name_first"] as? String
//        {
//            self.firstName = firstName
//        }
//        
//        if let lastName = dictLocal["name_last"] as? String
//        {
//            self.lastName = lastName
//        }
//        
//        
//        if let otpCode = dictLocal["confirmation_code"] as? NSNumber
//        {
//            self.otpCode = otpCode.description
//        }
        
        
        
      /*
         
          reponse for register Socially
        {
            confirmed = No;
            "device_token" = Simulator;
            "email_address" = "mannajassij@yahoo.com";
            id = 9;
            "name_first" = Maninderjit;
            "name_last" = Singh;
            "session_id" = "KF-367-970-20170531";
            "session_status" = 1;
            status = Active;
        }
        )
        
         
         
         response for register manually
        {
            confirmed = No;
            "device_token" = "<null>";
            "email_address" = "maninder.manna@xicom.biz";
            id = 10;
            "name_first" = 0;
            "name_last" = 0;
            "session_id" = "<null>";
            "session_status" = "<null>";
            status = Pending;
        }
        )
        
        */
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        
        let name: String? = aDecoder.decodeObject(forKey: "fullName") as? String
       
        if name != nil {
            self.fullName = name;
        }
        
        let strID : String? = aDecoder.decodeObject(forKey: "ID") as? String
        if strID != nil {
            self.ID = strID;
        }
        
        let phoneNumber: String? = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        if phoneNumber != nil {
            self.phoneNumber = phoneNumber;
        }
        
        let password: String? = aDecoder.decodeObject(forKey: "password") as? String
        if password != nil {
            self.password = password;
        }
        
        let sessionID: String? = aDecoder.decodeObject(forKey: "sessionID") as? String
        if sessionID != nil {
            self.sessionID = sessionID;
        }
        
        let nameFirst: String? = aDecoder.decodeObject(forKey: "firstName") as? String
        if nameFirst != nil {
            self.firstName = nameFirst!;
        }
        

        let nameLast: String? = aDecoder.decodeObject(forKey: "lastName") as? String
        if nameLast != nil {
            self.lastName = nameLast!;
        }
        
        
        let fbID : String? = aDecoder.decodeObject(forKey: "socialID") as? String
        if fbID != nil {
            self.socialID = fbID!;
        }

        
        let verifiedCheck  = aDecoder.decodeObject(forKey: "profileStatus") as? String
        if verifiedCheck != nil {
            self.profileStatus =  ProfileStatus(rawValue: verifiedCheck!)!
        }
        
         self.myCredits = aDecoder.decodeInteger(forKey: "myCredits")
        
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.fullName, forKey: "fullName")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.emailAddress, forKey: "emailAddress")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.ID, forKey: "ID")
        aCoder.encode(self.sessionID, forKey: "sessionID")
        aCoder.encode(self.socialID, forKey: "socialID")
        aCoder.encode(self.profileStatus.rawValue, forKey: "profileStatus")
        aCoder.encode(self.myCredits, forKey: "myCredits")
        aCoder.encode(self.myCredits, forKey: "myCredits")


    }
    
    

}
