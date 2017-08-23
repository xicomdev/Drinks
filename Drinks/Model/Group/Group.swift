//
//  Group.swift
//  Drinks
//
//  Created by maninder on 8/14/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit



class GroupLocation: NSObject {
    
    var occupation : Job? = nil
    
    var age : String? = nil
    
    
    override init() {
        
    }
    
    
    convenience init(dict : Any) {
        self.init()
        
    }
    
}




class GroupCondition: NSObject {
    
    var occupation : Job = Job()
  
    
    var age : Int = 0
    
    
    override init() {
        
    }
    
    
    convenience init(dict : Any) {
        self.init()
        
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
    var tagEnabled = false
      var groupConditions : [GroupCondition] = [GroupCondition]()
    var relationship : String = ""
    var groupDescription : String = ""
    
    override init()
    {
        
        
    }
    
    convenience init(groupDict : Any) {
        self.init()
        
    }

    
    
    func createNewGroup( image : [MSImage]  , handler : @escaping CompletionHandler)
    {
       // user_id, image
        let parms = ["user_id" : LoginManager.getMe.ID! ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_AddGroup, paramters: parms, Images: image) { (success, response, strError) in
            SwiftLoader.hide()
            if success{
                if let dictResponse = response as? Dictionary<String ,Any>
                {
                let dictUser = dictResponse["User"]  as? Dictionary<String ,Any>
                   if dictUser != nil
                    {
                        
                        
                }
//                        let meUser = User(dict: dictUser)
//                        //  self.me = meUser
                    
                    handler(true , dictResponse, strError)
                    
                    }
                
            }else{
                
                handler(true , "Group has been created", strError)
            }
        }

        
        
        
    }
    

}
