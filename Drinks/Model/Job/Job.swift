//
//  Job.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class Job: NSObject,NSCoding {
    
    var ID: String = ""
    var engName : String = ""
    var japName  : String = ""
    
    override init()
    {
        
        
    }
    
    convenience init(jobInfo : Any)
    {
        self.init()
        
        let dictJob = jobInfo as! Dictionary< String , Any>
        
        if let strID = dictJob["id"] as? String{
            self.ID = strID
        }else{
            
            self.ID = dictJob["ID"] as! String
            
        }
        self.engName = dictJob["eng_name"] as! String
        self.japName = dictJob["jap_name"] as! String
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        let ID: String? = aDecoder.decodeObject(forKey: "ID") as? String
        if ID != nil {
            self.ID = ID!;
        }
        
        let engName : String? = aDecoder.decodeObject(forKey: "engName") as? String
        if engName != nil {
            self.engName = engName!;
        }
        
        let japName : String? = aDecoder.decodeObject(forKey: "japName") as? String
        if japName != nil {
            self.japName = japName!;
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.ID, forKey: "ID")
        aCoder.encode(self.engName, forKey: "engName")
        aCoder.encode(self.japName, forKey: "japName")
        
    }
    
    
    class func getJobList()-> [Job]
    {
        var arrState = [Job]()
        
        if let dataList = defaults.object(forKey: stateLocal) as? NSData
        {
            if let decodedList = NSKeyedUnarchiver.unarchiveObject(with: dataList as Data) as? [Job]
            {
                arrState = decodedList
                
            }
        }
        return arrState
    }
    
    class func saveJobListing()
    {
//       if  defaults.object(forKey: stateLocal) as? NSData == nil
//        {
            HTTPRequest.sharedInstance().getRequest(urlLink: API_GetJobs, paramters: nil) { (isSuccess, response, strError) in
                if isSuccess{
                    if let response = response as? [String: Any]
                    {
                        
                        let arrayResponse = response["job_list"] as! [Any]
//                        print(arrayResponse)
                        var arrState = [Job]()
                        for item in arrayResponse
                        {
                            let state = Job(jobInfo: item)
                            arrState.append(state)
                        }
                        defaults.set(NSKeyedArchiver.archivedData(withRootObject: arrState), forKey: stateLocal)
                        
                        if let marriageAry = response["marriage_types"] as? [NSDictionary] {
                            if marriageAry.count > 0 {
                                arrayMarriage = []
                                for dict in marriageAry {
                                    if Locale.preferredLanguages[0].contains("en") {
                                        arrayMarriage.append(dict["eng_name"] as! String)
                                    }else {
                                        arrayMarriage.append(dict["jap_name"] as! String)
                                    }
                                }
                            }
                        }
                        
                        if let educationAry = response["education_types"] as? [NSDictionary] {
                            if educationAry.count > 0 {
                                arraySchool = []
                                for dict in educationAry {
                                    if Locale.preferredLanguages[0].contains("en") {
                                        arraySchool.append(dict["eng_name"] as! String)
                                    }else {
                                        arraySchool.append(dict["jap_name"] as! String)
                                    }
                                }
                            }
                        }
                        
                        if let relationAry = response["relationship_types"] as? [NSDictionary] {
                            if relationAry.count > 0 {
                                arrayRelations = []
                                for dict in relationAry {
                                    if Locale.preferredLanguages[0].contains("en") {
                                        arrayRelations.append(dict["eng_name"] as! String)
                                    }else {
                                        arrayRelations.append(dict["jap_name"] as! String)
                                    }
                                }
                            }
                        }
                        

                        if let salaryAry = response["salary_types"] as? [NSDictionary] {
                            if salaryAry.count > 0 {
                                arrayIncome = []
                                for dict in salaryAry {
                                    if Locale.preferredLanguages[0].contains("en") {
                                        arrayIncome.append(dict["eng_name"] as! String)
                                    }else {
                                        arrayIncome.append(dict["jap_name"] as! String)
                                    }
                                }
                            }
                        }
                        
                        if let tobacoAry = response["tobacco_types"] as? [NSDictionary] {
                            if tobacoAry.count > 0 {
                                arrayToabacco = []
                                for dict in tobacoAry {
                                    if Locale.preferredLanguages[0].contains("en") {
                                        arrayToabacco.append(dict["eng_name"] as! String)
                                    }else {
                                        arrayToabacco.append(dict["jap_name"] as! String)
                                    }
                                }
                            }
                        }
                    }
                }
            }
//        }
    }




}
