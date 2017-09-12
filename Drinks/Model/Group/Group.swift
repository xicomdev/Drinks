//
//  Group.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit



class GroupLocation: NSObject {
    
    var LocationName : String? = nil
    var latitude : Double!
    var longtitude : Double!
    
    var age : String? = nil
    
    
    override init() {
        
    }
    
    
    convenience init(name : String , lat : String , long : String) {
        self.init()
        self.LocationName = name
        if let latitude = Double(lat) {
             self.latitude = latitude
        }else{
             self.latitude = 0.0
        }
        
        if let longitude = Double(long) {
            self.longtitude = longitude
        }else{
            self.longtitude = 0.0
        }
    }
}




class GroupCondition: NSObject {
    
    var occupation : Job = Job()
    var age : Int = 0
    
    override init() {
        
    }
    
    
    convenience init(dict : Any) {
        self.init()
        
        let newDict = dict as! Dictionary<String, Any>
        
        occupation = Job(jobInfo: newDict)
        age = newDict["Age"] as! Int
    }
    
}



class Group: NSObject {
    
    
    class var sharedInstance: Group {
        struct Static {
            static let instance: Group = Group()
        }
        return Static.instance
    }

    var image : UIImage? = nil
    var imageURL : String!

    
    
    var tagEnabled = false
      var groupConditions : [GroupCondition] = [GroupCondition]()
    var relationship : String = ""
    var groupDescription : String = ""
    var groupID : String!
    var location : GroupLocation? = nil
    var ownerID : String!
    var groupOwner : User!
    
    var drinkedStatus : DrinkStatus = .NotDrinked
    var groupBy : GroupBy = .Other
    
    var reportedStatus : ReportedStatus = .NotReported
    
    override init()
    {
        
        
    }
    
    convenience init(groupDict : Any) {
        self.init()
        
        
        if let dictGroup = groupDict as? Dictionary<String, Any>
        {
           
            
            self.groupSetUp(dict: dictGroup)
            
            self.groupOwner = User(dictOwner:  dictGroup["user"] as Any)

            groupBy = .Other
            if self.ownerID == LoginManager.getMe.ID{
                groupBy = .My
            }
            
            if let tag = dictGroup["group_tag"] as? String{
                
                if tag == "1"{
                    self.tagEnabled = true
                }else{
                    self.tagEnabled = false
                }
            }
            
            if let drinkedStatus = dictGroup["drinked_status"] as? Bool{
                self.drinkedStatus = .NotDrinked
                if drinkedStatus == true{
                    self.drinkedStatus = .Drinked
                }
            }
            
            
        
            
            
            
//            
//            
//            "annual_income" = "$ 8000 - 15000";
//            "blood_type" = "AB+";
//            created =             {
//                sec = 1504372376;
//                usec = 936000;
//            };
//            dob = "1999/09/03";
//            "fb_id" = 1288672714577080;
//            "fb_image" = "http://graph.facebook.com/1288672714577080/picture?type=large";
//            "full_name" = "Jonghwa Park";
//            id = 59aae698a642be0a713f8384;
//            job =             {
//                "eng_name" = Ad;
//                id = 59a545e241a73f9c5a7711ea;
//                "jap_name" = "\U5e83\U544a";
//            };
//            "job_id" = 59a545e241a73f9c5a7711ea;
//            "last_login" = "";
//            marriage = UnMarried;
//            modified =             {
//                sec = 1504372376;
//                usec = 936000;
//            };
//            "reported_status" = 0;
//            "school_career" = "Ph.d";
//            tabaco = GHI;

        }
        
    }
    
    
    convenience init(chatGroup : Any) {
        self.init()
        
        if let dictGroup = chatGroup as? Dictionary<String, Any>
        {
            
           self.groupSetUp(dict: dictGroup)
            self.groupOwner = User(messageDict: dictGroup["user"] as Any)
           }
    }
    
    
    
    
    
    func groupSetUp(dict : Dictionary<String, Any>)
    {
        
    
        
        self.groupConditions = self.getConditionArray(strPara: dict["group_conditions"] as! String)
        self.groupDescription = dict["group_description"] as! String
        self.groupID = dict["id"] as! String
        
        
        print("GroupID     "  + self.groupID)
        self.relationship = dict["relationship"] as! String
        self.imageURL = dict["image"] as! String
        self.location = GroupLocation(name: dict["group_location"] as! String, lat: dict["group_latitude"] as! String, long: dict["group_longitude"] as! String)
        self.ownerID = dict["user_id"] as! String

       if let drinkedStatus = dict["drinked_status"] as? Bool{
            self.drinkedStatus = .NotDrinked
            if drinkedStatus == true{
                self.drinkedStatus = .Drinked
            }
        }
        self.groupOwner = User(messageDict: dict["user"] as Any)
    }
    
   class func getGroupListing( handler : @escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetGroups, paramters: nil) { (isSuccess, response, strError) in
             SwiftLoader.hide()
            if isSuccess
            {
                var arrayList = [Group]()
                
                if let arryResponse = response as? [Dictionary<String ,Any>]
                {

                    for item in arryResponse{
                      let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayList.append(groupNew)
                    }
                }
                handler(true , arrayList, strError)
            }else{
                handler(false , nil, strError)
            }
        }
    }

    
    class func getFilteredGroupListing( filterInfo : FilterInfo ,  handler : @escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        
        var params : [String : Any] = [String : Any]()
        
        if appDelegate().appLocation != nil
        {
            params["current_latitude"] = appDelegate().appLocation?.latitude
            params["current_longitude"] = appDelegate().appLocation?.longtitude
        }

        if filterInfo.distance != -1{
            params["place"] = filterInfo.distance
        }
        if filterInfo.age.count != 0 {
            params["age"] = getStringToDisplay(array: filterInfo.age, type: .Age)
        }
        if filterInfo.job.count != 0 {
            params["job"] = getStringToDisplay(array: filterInfo.job, type: .Job)
        }
        
        if filterInfo.relation.count != 0 {
            params["relationship"] = getStringToDisplay(array: filterInfo.relation, type: .Relation)
        }
        
        if filterInfo.people.count != 0 {
            params["number_people"] = getStringToDisplay(array: filterInfo.people, type: .NumberOfPeople)

        }
        print(params)
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetGroups, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var arrayList = [Group]()
                
                if let arryResponse = response as? [Dictionary<String ,Any>]
                {
                    
                    for item in arryResponse{
                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayList.append(groupNew)
                    }
                }
                handler(true , arrayList, strError)
            }else{
                handler(false , nil, strError)
            }
        }
    }
    
    
    func createNewGroup( image : [MSImage]  , handler : @escaping CompletionHandler)
    {
       // user_id, image
        
        let groupMembers = createParameters(group: self)
        
        let parms : [String : Any] = ["user_id" : LoginManager.getMe.ID , "group_conditions" : groupMembers, "group_location" : location?.LocationName ,"group_latitude" : location?.latitude,"group_longitude" : location?.longtitude , "group_description" : self.groupDescription , "relationship" : self.relationship , "group_tag" : self.tagEnabled]
        
        
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_AddGroup, paramters: parms, Images: image) { (success, response, strError) in
            SwiftLoader.hide()
            if success{
                if let dictResponse = response as? Dictionary<String ,Any>
                {
              if  let dictGroup = dictResponse["Group"]  as? Dictionary<String ,Any>
              {
                let  groupNew = Group(groupDict: dictGroup)
                      handler(true , groupNew, strError)
                    }
              }
            }else{
                
                handler(false , nil, strError)
            }
        }
    }
    
    
    func editGroup( image : [MSImage]  , handler : @escaping CompletionHandler)
    {
        // user_id, image
        
        let groupMembers = createParameters(group: self)
        
        let parms : [String : Any] = ["user_id" : LoginManager.getMe.ID , "group_conditions" : groupMembers, "group_location" : location?.LocationName ,"group_latitude" : location?.latitude,"group_longitude" : location?.longtitude , "group_description" : self.groupDescription , "relationship" : self.relationship , "group_tag" : self.tagEnabled , "id" : self.groupID]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_EditGroup, paramters: parms, Images: image) { (success, response, strError) in
            SwiftLoader.hide()
            if success{
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                    if  let dictGroup = dictResponse["Group"]  as? Dictionary<String ,Any>
                    {
                        let  groupNew = Group(groupDict: dictGroup)
                        handler(true , groupNew, strError)
                    }
                }
            }else{
                
                handler(false , nil, strError)
            }
        }
    }
    
    
    func reportGroup( reason : String , date : String,  handler : @escaping CompletionHandler)
    {
        let params : [String : Any] = ["group_id" : self.groupID! , "reason" : reason , "date" : date , "group_reported_status" : true]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_ReportGroup, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                        handler(true , dictResponse, nil)
                }
            }else{
                
                handler(false , nil, strError)
            }
        }
    }
    
    
    func deleteGroup(handler : @escaping CompletionHandler)
    {
        let params : [String : Any] = ["id" : self.groupID! ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postRequest(urlLink: API_DeleteGroup, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                    handler(true , "Group Deleted", nil)
            }else{
                
                handler(false , nil, strError)
            }
        }
    }
    
    func createParameters(group : Group) -> String
    {
        let arrConds = group.groupConditions
        var arrayNew = [[String : Any]]()
        
        for item in arrConds
        {
            var newDict = [String : Any]()
            newDict["Age"] = item.age
            newDict["id"] = item.occupation.ID
            newDict["eng_name"] = item.occupation.engName
            newDict["jap_name"] = item.occupation.japName
            arrayNew.append(newDict)
        }
        return JSONString(paraObject: arrayNew)
    }
    
    
//    func createParameter(group : Group) -> [Dictionary<String,Any>]
//    {
//        let arrConds = group.groupConditions
//        var arrayNew = [Dictionary<String,Any>]()
//        
//        for item in arrConds
//        {
//            var newDict = Dictionary<String,Any>()
//            newDict["Age"] = item.age
//            newDict["id"] = item.occupation.ID
//            newDict["eng_name"] = item.occupation.engName
//            newDict["jap_name"] = item.occupation.japName
//            
//            arrayNew.append(newDict)
//        }
//        
//        
//        print(arrayNew)
//        return arrayNew
//    }

    
    func getConditionArray(strPara : String) -> [GroupCondition]
    {
        var arrayReturn = [GroupCondition]()
            if let data = strPara.data(using: String.Encoding.utf8) {
                do {
                    let jsonArry = try JSONSerialization.jsonObject(with: data, options: []) as?   [[String : Any]]
                    
                    for item in jsonArry!
                    {
                        let newDict = GroupCondition(dict: item)
                        arrayReturn.append(newDict)
                    }
                } catch {
                    // Handle error
                    print(error)
                }
            }
        
        
        
        return arrayReturn
    }
    
    //MARK:- Get Index of Object
    //MARK:-
    
  class func getIndex(arrayGroups : [Group] , group : Group) -> Int
    {
        let groupFiltered = arrayGroups.filter {
            ($0.groupID == group.groupID )
        }
        if groupFiltered.count > 0
        {
            return arrayGroups.index(of: groupFiltered[0])!
        }else{
            return arrayGroups.count
        }
    }

}
