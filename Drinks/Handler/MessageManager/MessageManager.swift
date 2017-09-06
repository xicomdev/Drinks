//
//  MessageManager.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import CoreData

class MessageManager: NSObject  {
    
    static let shared = MessageManager()
    
    private override init()
    {
        
    }

    func saveMsgs(_ aryMsgs: [Dictionary<String ,Any>]){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedContext)
        for msgDict in aryMsgs {
            
            let msgObj = NSManagedObject(entity: entity!, insertInto: managedContext)
            msgObj.setValue(msgDict["msgId"] as! String, forKey: "msgId")
            msgObj.setValue(msgDict["msgContent"] as! String, forKey: "msgContent")
            msgObj.setValue(msgDict["timestamp"] as! String, forKey: "timestamp")
            msgObj.setValue(msgDict["senderId"] as! String, forKey: "senderId")
            msgObj.setValue(msgDict["recieverId"] as! String, forKey: "recieverId")
            
            do {
                try managedContext.save()
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func getMsgs(_ userId: String) -> [Message] {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Message")
        
        var aryFetched : [NSManagedObject] = []
        
        do {
            aryFetched = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var aryMsgs = [Message]()
        for msg in aryFetched {
            let msgObj = Message()
            msgObj.msgId = msg.value(forKey: "msgId") as! String
            msgObj.msgContent = msg.value(forKey: "msgContent") as! String
            msgObj.timestamp = msg.value(forKey: "timestamp") as! String
            msgObj.senderId = msg.value(forKey: "senderId") as! String
            msgObj.recieverId = msg.value(forKey: "recieverId") as! String
            if userId == msgObj.recieverId || userId == msgObj.senderId {
                aryMsgs.append(msgObj)
            }
        }
        
        return aryMsgs
    }

}
