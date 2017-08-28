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


    
    override init()
    {
        
        
    }
    
    convenience init(groupDict : Any) {
        self.init()
        
        
        if let dictGroup = groupDict as? Dictionary<String, Any>
        {
            
            print(dictGroup)
            print(dictGroup["group_conditions"] as! String)
        
        self.groupConditions = self.getConditionArray(strPara: dictGroup["group_conditions"] as! String)
        self.groupDescription = dictGroup["group_description"] as! String
        self.groupID = dictGroup["id"] as! String
        self.relationship = dictGroup["relationship"] as! String
        self.imageURL = dictGroup["image"] as! String
        self.location = GroupLocation(name: dictGroup["group_description"] as! String, lat: dictGroup["group_latitude"] as! String, long: dictGroup["group_longitude"] as! String)
        self.ownerID = dictGroup["user_id"] as! String
        self.groupOwner = User(dictOwner: dictGroup["user"])
            
        
            if let tag = dictGroup["group_tag"] as? Bool{
                self.tagEnabled = tag
                
            }
            
            
        }
        
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
        
//        "user_id(optional if you send this then it will return groups of that user otherwise all),
//        current_latitude, current_longitude, place(like 10,30,100,0)[Only when you want to filter on this basis] ,
//        number_people(comma separated string like (1,2,3)),
//        relationship (comma separated name of relations),
//        age (comma separated ranges like 20-15, 30-35),
//        job_id (comma separated ids like 001,005)"
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
        
        let parms : [String : Any] = ["user_id" : LoginManager.getMe.ID! , "group_conditions" : groupMembers, "group_location" : location?.LocationName! ,"group_latitude" : location?.latitude!,"group_longitude" : location?.longtitude! , "group_description" : self.groupDescription , "relationship" : self.relationship , "group_tag" : self.tagEnabled]
        
        print(parms)
        
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
    
    
    
    
    
    
    
    
    func createParameters(group : Group) -> String
    {
        let arrConds = group.groupConditions
        var arrayNew = [[String : Any]]()
        
        for item in arrConds
        {
            
//            var ID: String = ""
//            var engName : String = ""
//            var japName  : String = ""
            var newDict = [String : Any]()
            newDict["Age"] = item.age
            newDict["id"] = item.occupation.ID
            newDict["eng_name"] = item.occupation.engName
            newDict["jap_name"] = item.occupation.japName

            arrayNew.append(newDict)
        }
        
        print(arrayNew)
        return JSONString(paraObject: arrayNew)
    }
    
    
    func createParameter(group : Group) -> [Dictionary<String,Any>]
    {
        let arrConds = group.groupConditions
        var arrayNew = [Dictionary<String,Any>]()
        
        for item in arrConds
        {
            
            //            var ID: String = ""
            //            var engName : String = ""
            //            var japName  : String = ""
            var newDict = Dictionary<String,Any>()
            newDict["Age"] = item.age
            newDict["id"] = item.occupation.ID
            newDict["eng_name"] = item.occupation.engName
            newDict["jap_name"] = item.occupation.japName
            
            arrayNew.append(newDict)
        }
        
        
        print(arrayNew)
        return arrayNew
    }

    
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
    
    

}
