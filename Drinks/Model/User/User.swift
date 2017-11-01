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

let appLastLoginFormat = DateFormatter()

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
    var otpCode : String = ""
    var job : Job = Job()
    var notificationSettings = Notifications()
    var DOB : String = ""
    var bloodGroup : String = ""
    var relationship : String = ""
    var tabaco : String = ""
    var schoolCareer : String = ""
    var annualIncome : String = ""
    var imageURL : String = ""
    var lastLogin : String = ""
    var age : Int = 18
    var membershipStatus : String = ""
    var offersCount : String = "0"
    var myCredits : String = "0"
    var myCouponCode = ""
    var myGender : Gender = .Male
    var groupCreated : Int = 0
    var ageVerified: String = ""
    var ageDocument : String = ""
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
    
    convenience init(dictOnlyID : String) {
        self.init()
        
        self.ID = dictOnlyID
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
        
        if let lastLogin = dictLocal["last_login"] as? String{
            
            //let date = lastLoginDateFormat.date(from: lastLogin)
            self.lastLogin = lastLogin
            
            
        }
        
        if let ageDocument = dictLocal["age_document"] as? String {
            self.ageDocument = ageDocument
        }
        
        if let ageVerified = dictLocal["is_age_verified"] as? Bool {
            self.ageVerified = String(ageVerified)
        }
        
    }

    
    convenience init(messageDict : Any) {
        self.init()
        
        
        guard let dictLocal = messageDict as? Dictionary<String, Any> else {
            return
        }
        
        if let job = dictLocal["job"] as? Dictionary<String, Any>
        {
            self.job = Job(jobInfo: job as Any)
            
        }
        self.fullName = dictLocal["full_name"] as! String
        self.setImage(dict: dictLocal)
        self.ID = dictLocal["id"] as! String
        
        
        if let strDOB = dictLocal["dob"] as? String
        {
            self.DOB = dictLocal["dob"] as! String
            self.age = strDOB.getAgeFromDOB()
        }

        
        if let lastLogin = dictLocal["last_login"] as? String{
           // let date = lastLoginDateFormat.date(from: lastLogin)
           // print(date)
            self.lastLogin = lastLogin
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

        let myCredits : String? = aDecoder.decodeObject(forKey: "myCredits") as? String
        if myCredits != nil
        {
            self.myCredits = myCredits!;
        }
        
        let membershipStatus : String? = aDecoder.decodeObject(forKey: "membershipStatus") as? String
        if membershipStatus != nil
        {
            self.membershipStatus = membershipStatus!;
        }
        
        
        let offersCount : String? = aDecoder.decodeObject(forKey: "offersCount") as? String
        if offersCount != nil
        {
            self.offersCount = offersCount!;
        }
        
        
        let myCouponCode : String? = aDecoder.decodeObject(forKey: "myCouponCode") as? String
        if myCouponCode != nil {
            self.myCouponCode = myCouponCode!
        }
        
        let job : Job? = aDecoder.decodeObject(forKey: "job") as? Job
        if job != nil {
            self.job = job!;
        }
        
        self.age = aDecoder.decodeInteger(forKey: "age")
        
        self.groupCreated = aDecoder.decodeInteger(forKey: "groupCreated")

        
        
        let ageVerified : String? = aDecoder.decodeObject(forKey: "ageVerified") as? String
        if ageVerified != nil
        {
            self.ageVerified = ageVerified!;
        }
        
        let dob : String? = aDecoder.decodeObject(forKey: "DOB") as? String
        if dob != nil
        {
            self.DOB = dob!;
        }
        
        let ageDocument : String? = aDecoder.decodeObject(forKey: "ageDocument") as? String
        if ageDocument != nil
        {
            self.ageDocument = dob!;
        }
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.ageDocument, forKey: "ageDocument")
        aCoder.encode(self.ageVerified, forKey: "ageVerified")
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
        aCoder.encode(self.myCredits, forKey: "myCredits")
        aCoder.encode(self.membershipStatus, forKey: "membershipStatus")
        aCoder.encode(self.offersCount, forKey: "offersCount")
        aCoder.encode(self.DOB, forKey: "DOB")
        aCoder.encode(self.myCouponCode, forKey: "myCouponCode")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.groupCreated, forKey: "groupCreated")




    }
    
    

}
