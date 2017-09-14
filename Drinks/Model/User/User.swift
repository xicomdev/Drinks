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

    var age : Int = 18
    
    
    var myGender : Gender = .Male
    var groupCreated : Int = 0
    //var profileStatus : ProfileStatus = .Pending
    
    
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
        
        
        
        
    }
    
    
    
    
    
    convenience init(dictOwner : Any) {
        self.init()
        
        
        guard let dictLocal = dictOwner as? Dictionary<String, Any> else {
            return
        }
        
        self.job = Job(jobInfo: dictLocal["job"] as Any)
        self.fullName = dictLocal["full_name"] as! String
        self.setImage(dict: dictLocal)
        self.ID = dictLocal["id"] as! String

        if let strDOB = dictLocal["dob"] as? String
        {
            self.DOB = dictLocal["dob"] as! String

            self.age = strDOB.getAgeFromDOB()
        }
        
        
        if let annualIncome = dictLocal["annual_income"] as? String{
            
            self.annualIncome = annualIncome
 
        }
        if let schoolCareer = dictLocal["school_career"] as? String{
            
            self.schoolCareer = schoolCareer

        }
        if let tabacoInfo = dictLocal["tabaco"] as? String
        {
            
            self.tabaco = tabacoInfo
        }
        
        if let bloodType = dictLocal["blood_type"] as? String{
           
            self.bloodGroup = bloodType
            
        }
        if let relationship = dictLocal["marriage"] as? String{
            
            self.relationship = relationship
        }
        
    }

    
    convenience init(messageDict : Any) {
        self.init()
        
        
        guard let dictLocal = messageDict as? Dictionary<String, Any> else {
            return
        }
        
        
        if let job = dictLocal["job"] as? Dictionary<String, Any>
        {
            self.job = Job(jobInfo: dictLocal["job"] as Any)
            
        }
        self.fullName = dictLocal["full_name"] as! String
        self.setImage(dict: dictLocal)
        self.ID = dictLocal["id"] as! String
        
        
        if let strDOB = dictLocal["dob"] as? String
        {
            self.DOB = dictLocal["dob"] as! String
            self.age = strDOB.getAgeFromDOB()
        }

        
    }
    
    
    
    
    func setImage(dict : Dictionary<String, Any> )
    {
        if let imageURL = dict["image"] as? String
        {
            self.imageURL = imageURL
        }else if let fbImageURL = dict["fb_image"] as? String
        {
            self.imageURL = fbImageURL
        }
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
        

        
        let sessionID: String? = aDecoder.decodeObject(forKey: "sessionID") as? String
        if sessionID != nil {
            self.sessionID = sessionID;
        }
        

        
        let fbID : String? = aDecoder.decodeObject(forKey: "socialID") as? String
        if fbID != nil {
            self.socialID = fbID!;
        }
        
        let imgeURL : String? = aDecoder.decodeObject(forKey: "imageURL") as? String
        if imgeURL != nil {
            self.imageURL = imgeURL!;
        }

        
        let schoolCareer : String? = aDecoder.decodeObject(forKey: "schoolCareer") as? String
        if schoolCareer != nil {
            self.schoolCareer = schoolCareer!;
        }
        
        let relationship : String? = aDecoder.decodeObject(forKey: "relationship") as? String
        if relationship != nil {
            self.relationship = relationship!;
        }

        
        let annualIncome : String? = aDecoder.decodeObject(forKey: "annualIncome") as? String
        if annualIncome != nil {
            self.annualIncome = annualIncome!;
        }
        
        
        let bloodGroup : String? = aDecoder.decodeObject(forKey: "bloodGroup") as? String
        if bloodGroup != nil {
            self.bloodGroup = bloodGroup!;
        }

        
        let tabaco : String? = aDecoder.decodeObject(forKey: "tabaco") as? String
        if tabaco != nil
        {
            self.tabaco = tabaco!;
        }

        let job : Job? = aDecoder.decodeObject(forKey: "job") as? Job
        if job != nil {
            self.job = job!;
        }
        
      self.age = aDecoder.decodeInteger(forKey: "age")
        
        self.groupCreated = aDecoder.decodeInteger(forKey: "groupCreated")

        
        
        let dob : String? = aDecoder.decodeObject(forKey: "DOB") as? String
        if dob != nil
        {
            self.DOB = dob!;
        }
        
        
//        if job != nil {
//            self.age = job!;
//        }
        
       
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.fullName, forKey: "fullName")
        aCoder.encode(self.emailAddress, forKey: "emailAddress")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.ID, forKey: "ID")
        aCoder.encode(self.sessionID, forKey: "sessionID")
        aCoder.encode(self.socialID, forKey: "socialID")
        aCoder.encode(self.annualIncome, forKey: "annualIncome")
        aCoder.encode(self.relationship, forKey: "relationship")
        aCoder.encode(self.schoolCareer, forKey: "schoolCareer")
        aCoder.encode(self.bloodGroup, forKey: "bloodGroup")
        aCoder.encode(self.tabaco, forKey: "tabaco")
        aCoder.encode(self.imageURL, forKey: "imageURL")
        aCoder.encode(self.job, forKey: "job")

        aCoder.encode(self.DOB, forKey: "DOB")

        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.groupCreated, forKey: "groupCreated")




    }
    
    

}
