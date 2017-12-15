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
    var latitude : Double = 0.0
    var longtitude : Double = 0.0
    
    var age : String? = nil
    
    
    override init() {
        
    }
    
    
    convenience init(name : String , lat : Double , long : Double) {
        self.init()
        self.LocationName = name
        self.latitude = lat
        
        self.longtitude = long
        
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

    
    var distance : Double = 0.0
    
    var image : UIImage? = nil
    var imageURL : String!

    var groupRequest : Group? = nil
    
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
                
                
                self.groupOwner = LoginManager.getMe
            }
            
            if let tag = dictGroup["group_tag"] as? String{
                
                if tag == "1"{
                    self.tagEnabled = true
                }else{
                    self.tagEnabled = false
                }
            }
            
            if let drinkedStatus = dictGroup["drinked_status"] as? String
            {
                self.drinkedStatus =  DrinkStatus(rawValue: drinkedStatus)!
            }
            
            if let relation = dictGroup["relationship"] as? String {
                self.relationship = relation
            }
            
            if let distance = dictGroup["distance"] as? Double
            {
                self.distance = distance.roundTo(places: 2)
                
                
            }
            
            

        }
        
    }
    
    
    
    
    
    
    //Init for Beoffered with Drinked Request
    
    convenience init(groupBoth : Any) {
        self.init()
        
        
        if let dictBoth = groupBoth as? Dictionary<String, Any>
        {
            
            
            let dictGroup = dictBoth["Group"]  as! Dictionary<String ,Any> // Other USer Group
//            let myGroup = dictBoth["DrinkedGroup"]  as! Dictionary<String ,Any> // Other USer Performed action on My Group
            
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
            
            if let drinkedStatus = dictGroup["drinked_status"] as? String
            {
                self.drinkedStatus =  DrinkStatus(rawValue: drinkedStatus)!
            }
            self.groupRequest = Group(groupDrinked: dictBoth["DrinkedGroup"] as Any)
            
           
            
            if let distance = dictGroup["distance"] as? Double
            {
                self.distance = distance.roundTo(places: 2)
            }
            
        }
        
    }
    
    
    
    convenience init(groupDrinked : Any) {
        self.init()
        
        
        if let dictDrinkedGroup = groupDrinked as? Dictionary<String, Any>
        {
            self.groupID = dictDrinkedGroup["group_id"] as! String
            
            self.groupOwner = User(dictOnlyID: dictDrinkedGroup["user_id"] as! String)
            
            
            if let distance = dictDrinkedGroup["distance"] as? Double
            {
                self.distance = distance.roundTo(places: 2)
            }
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
        
        
        self.relationship = dict["relationship"] as! String
        self.imageURL = dict["image"] as! String
        self.location = GroupLocation(name: dict["group_location"] as! String, lat: Double(dict["group_latitude"] as! String)!, long: Double(dict["group_longitude"] as! String)!)
        self.ownerID = dict["user_id"] as! String

        if let drinkedStatus = dict["drinked_status"] as? String
        {
            self.drinkedStatus =  DrinkStatus(rawValue: drinkedStatus)!
        }

        self.groupOwner = User(messageDict: dict["user"] as Any)
    }
    
   class func getGroupListing( handler : @escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        var params : [String : Any] = [String : Any]()

       
        
        if appDelegate().appLocation != nil
        {
            params["current_latitude"] = appDelegate().appLocation?.latitude
            params["current_longitude"] = appDelegate().appLocation?.longtitude
        }
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetGroups, paramters: params) { (isSuccess, response, strError) in
             SwiftLoader.hide()
            if isSuccess
            {
                var dictReturning = [String : Any]()
                var arrayGroup = [Group]()
                var arrayMyGroup = [Group]()
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                   
                    
                    if dictResponse.count > 0 {
                    
                    let allGroups = dictResponse["groups"] as! [Dictionary<String ,Any>]
                    let myGroups = dictResponse["myGroups"] as! [Dictionary<String ,Any>]

                    for item in allGroups
                    {
                        
                        
                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayGroup.append(groupNew)
                        
                    }
                    
                    for item in myGroups{
                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                        let  groupNew = Group(groupDict: dictGroup)
                        arrayMyGroup.append(groupNew)
                    }
                   }
                }
                
                dictReturning["MyGroups"] = arrayMyGroup
                dictReturning["OtherGroups"] = arrayGroup
                handler(true , dictReturning, strError)
            }else{
                handler(false , nil, strError)
            }
        }
    }

    
    class func getFilteredGroupListing( filterInfo : FilterInfo, sortInfo: SortInfo , handler : @escaping CompletionHandler)
    {
        SwiftLoader.show(true)
        
        var params : [String : Any] = [String : Any]()
        

        
        if filterInfo.filterLocationName != nil{
            
            params["current_latitude"] = filterInfo.filterLocationName?.latitude
            params["current_longitude"] = filterInfo.filterLocationName?.longtitude
            
        }else if appDelegate().appLocation != nil{
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
        
        var sortValues = ""
        if sortInfo.Place == "Closer order"{
            sortValues = sortValues + "distance_asc"
        }else if sortInfo.Place == "In order of distance" {
            sortValues = sortValues + ", distance_desc"
        }
        
        if sortInfo.age == "High to low"{
            sortValues = sortValues + ", age_asc"
        }else if sortInfo.age == "Low to high" {
            sortValues = sortValues + ", age_desc"
        }
        
        if sortInfo.Offers == "Most to least"{
            sortValues = sortValues + ", offer_asc"
        }else if sortInfo.Offers == "Less in order" {
            sortValues = sortValues + ", offer_desc"
        }
        
        if sortInfo.LastLogin == "Closer order"{
            sortValues = sortValues + ", login_new"
        }else if sortInfo.LastLogin == "Oldest first" {
            sortValues = sortValues + ", login_old"
        }
        if sortValues != "" {
            params["sort_value"] = sortValues.trimmingCharacters(in: CharacterSet(charactersIn: ", "))
        }
        print(params)
        
        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetGroups, paramters: params) { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess
            {
                var dictReturning = [String : Any]()
                var arrayGroup = [Group]()
                var arrayMyGroup = [Group]()
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                    
                    
                    if dictResponse.count > 0 {
                        
                        let allGroups = dictResponse["groups"] as! [Dictionary<String ,Any>]
                        let myGroups = dictResponse["myGroups"] as! [Dictionary<String ,Any>]
                        
                        for item in allGroups
                        {
                            
                            
                            let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                            let  groupNew = Group(groupDict: dictGroup)
                            arrayGroup.append(groupNew)
                            
                        }
                        
                        for item in myGroups{
                            let dictGroup = item["Group"]  as! Dictionary<String ,Any>
                            let  groupNew = Group(groupDict: dictGroup)
                            arrayMyGroup.append(groupNew)
                        }
                    }
                }
                
                dictReturning["MyGroups"] = arrayMyGroup
                dictReturning["OtherGroups"] = arrayGroup
                handler(true , dictReturning, strError)
            }else{
                handler(false , nil, strError)
            }
        }
    }
    
//    class func getSortedGroupListing( sortInfo : SortInfo ,  handler : @escaping CompletionHandler)
//    {
//        SwiftLoader.show(true)
//
//        var params : [String : Any] = [String : Any]()
//
//
//
//        if sortInfo.filterLocationName != nil{
//
//            params["current_latitude"] = sortInfo.filterLocationName?.latitude
//            params["current_longitude"] = sortInfo.filterLocationName?.longtitude
//
//        }else if appDelegate().appLocation != nil{
//            params["current_latitude"] = appDelegate().appLocation?.latitude
//            params["current_longitude"] = appDelegate().appLocation?.longtitude
//        }
//        var sortValues = ""
//        if sortInfo.Place == "Ascending"{
//            sortValues = sortValues + "distance_asc"
//        }else if sortInfo.Place == "Descending" {
//            sortValues = sortValues + ", distance_desc"
//        }
//
//        if sortInfo.age == "Ascending"{
//            sortValues = sortValues + ", age_asc"
//        }else if sortInfo.age == "Descending" {
//            sortValues = sortValues + ", age_desc"
//        }
//
//        if sortInfo.Offers == "Ascending"{
//            sortValues = sortValues + ", offer_asc"
//        }else if sortInfo.Offers == "Descending" {
//            sortValues = sortValues + ", offer_desc"
//        }
//
//        if sortInfo.LastLogin == "Recent"{
//            sortValues = sortValues + ", login_new"
//        }else if sortInfo.LastLogin == "Older" {
//            sortValues = sortValues + ", login_old"
//        }
//        if sortValues != "" {
//            params["sort_value"] = sortValues.trimmingCharacters(in: CharacterSet(charactersIn: ", "))
//        }
//        print(params)
//
//        HTTPRequest.sharedInstance().postRequest(urlLink: API_GetGroups, paramters: params) { (isSuccess, response, strError) in
//            SwiftLoader.hide()
//            if isSuccess
//            {
//                var arrayList = [Group]()
//
//                if let arryResponse = response as? [Dictionary<String ,Any>]
//                {
//
//                    for item in arryResponse{
//                        let dictGroup = item["Group"]  as! Dictionary<String ,Any>
//                        let  groupNew = Group(groupDict: dictGroup)
//                        arrayList.append(groupNew)
//                    }
//                }
//                handler(true , arrayList, strError)
//            }else{
//                handler(false , nil, strError)
//            }
//        }
//    }
    
    func createNewGroup( image : [MSImage]  , handler : @escaping CompletionHandler)
    {
       // user_id, image
        
        let groupMembers = createParameters(group: self)
        
        let parms : [String : Any] = ["user_id" : LoginManager.getMe.ID , "group_conditions" : groupMembers, "group_location" : (location?.LocationName)! ,"group_latitude" : (location?.latitude)!,"group_longitude" : (location?.longtitude)! , "group_description" : self.groupDescription , "relationship" : self.relationship , "group_tag" : self.tagEnabled]
        
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
    
    
    func editGroup( image : [MSImage]  , handler : @escaping CompletionHandler)
    {
        // user_id, image
        
        let groupMembers = createParameters(group: self)
        
        let parms : [String : Any] = ["user_id" : LoginManager.getMe.ID , "group_conditions" : groupMembers, "group_location" : location?.LocationName ,"group_latitude" : (location?.latitude)!,"group_longitude" : (location?.longtitude)! , "group_description" : self.groupDescription , "relationship" : self.relationship , "group_tag" : self.tagEnabled , "id" : self.groupID]
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
        var arrConds = [GroupCondition]()
        for item in group.groupConditions {
            if item.age != 0 ||  item.occupation.ID != "" {
                arrConds.append(item)
            }
        }
        
        
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
