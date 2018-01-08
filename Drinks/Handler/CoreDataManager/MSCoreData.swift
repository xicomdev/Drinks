//
//  MSCoreData.swift
//  iCheckbook

//  Created by maninder on 02/03/17.
//  Copyright © 2017 maninder. All rights reserved.
//  +91 7837820722 Maninderjit Singh



import UIKit
import CoreData


let entityUser = "UserEntity"
let entityGroup = "GroupEntity"
let entityThread = "ThreadEntity"
let entityMessage = "MessageEntity"



class MSCoreData: NSObject {
    /*  Handling core data methods for saving, updating, fetching accounts,
     saving, updating, fetching simpel transaction and recurring transactions information
     and saving security information used for authentication purposes
     */
    
    class var sharedInstance: MSCoreData {
        //Shared Instance declaration *(Single time initialization)
        struct Static {
            static let instance: MSCoreData = MSCoreData()
        }
        return Static.instance
    }
    
    //MARK:- Threads
    //MARK:-
    
    //Check whether it is already in Core data
    
    func fetchParticularThread(threadID : String) -> ThreadEntity?
    {
        let request = self.createThreadFetchRequest()
        let predicate = NSPredicate(format: "threadID == %@",threadID)
        request.predicate = predicate
        do {
            let list = try  appDelegate().managedObjectContext.fetch(request)
            if list.count > 0
            {
                return list[0]
                //adding to returning account list
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    //Check Either creates new one or return previous one

    func getThreadEntity(dictComplete : Dictionary<String, Any>) -> ThreadEntity
        {
     
            let strThreadID  = dictComplete["thread_id"] as! String
            let groupInfo =  dictComplete["group_info"] as! Dictionary<String, Any>
            if let threadPrevious =  self.fetchParticularThread(threadID: strThreadID)
          {
            threadPrevious.group = self.createGroupEntity(dict: groupInfo)
            return threadPrevious
            
         }else
            {
            
            let ent = NSEntityDescription.entity(forEntityName: entityThread , in: appDelegate().managedObjectContext)
            let thread = ThreadEntity(entity: ent!, insertInto: appDelegate().managedObjectContext)
            thread.threadID = strThreadID
            thread.group = self.createGroupEntity(dict: groupInfo)
                return thread
                
            }
    }
    
    //Creates user entity
    func createSenderEntity(dictUser  : Dictionary<String, Any>) -> UserEntity
        {
            let userInfo = dictUser
            let ent = NSEntityDescription.entity(forEntityName: entityUser , in: appDelegate().managedObjectContext)
            let user = UserEntity(entity: ent!, insertInto: appDelegate().managedObjectContext)
            
          
            user.userID = userInfo["id"]  as? String
            user.userName = userInfo["full_name"]  as? String
            user.userOccupation = userInfo["job_id"]  as? String
            
            if let imageURL = userInfo["image"] as? String
            {
                user.userImageURL =  imageURL
                
            }else if let fbImageURL = userInfo["fb_image"] as? String
            {
             user.userImageURL = fbImageURL
            }
            
            if let strDOB = userInfo["dob"] as? String
            {
                user.userDOB = strDOB
                if strDOB != "" {
                    user.userAge = Int16(strDOB.getAgeFromDOB())
                }else {
                    user.userAge = 0
                }
            }
            
            if let strIncome = userInfo["annual_income"] as? String
            {
                user.userIncome = strIncome
            }
            
            if let strBloodType = userInfo["blood_type"] as? String
            {
                user.userBlood = strBloodType
            }
            
  
            if let strTabaco = userInfo["tabaco"] as? String
            {
                user.userTabbaco = strTabaco
            }
            
            if let strSchool = userInfo["school_career"] as? String
            {
                user.userEducation = strSchool
            }
            
            
            if let strMarriage = userInfo["marriage"] as? String
            {
                user.userRelationship = strMarriage
            }
            return user
        
        }
    
    
    //Creates login user entity
    func createMySelfEntity() -> UserEntity
        {
            let ent = NSEntityDescription.entity(forEntityName: entityUser , in: appDelegate().managedObjectContext)
            let user = UserEntity(entity: ent!, insertInto: appDelegate().managedObjectContext)
            user.userID = LoginManager.getMe.ID
            return user
        }
    
    
    func createGroupEntity(dict  : Dictionary<String, Any>)-> GroupEntity
        {
            let ent = NSEntityDescription.entity(forEntityName: entityGroup , in: appDelegate().managedObjectContext)
            let group = GroupEntity(entity: ent!, insertInto: appDelegate().managedObjectContext)
            group.groupID = dict["id"] as? String
            group.groupOwner = self.createSenderEntity(dictUser: dict)
            group.groupImageURL = dict["image"] as? String
            group.groupLocation =  dict["group_location"] as? String
            if let tag = dict["group_tag"] as? String{
                if tag == "1"
                {
                  group.groupTag  = true
                }else{
                  group.groupTag  = false
                }
            }
            
            group.groupBy = "OtherGroup"
            
            if LoginManager.getMe.ID == group.groupOwner?.userID{
                group.groupBy = "MyGroup"
            }
             let groupCondition = Group.sharedInstance.getConditionArray(strPara: (dict["group_conditions"] as? String)!)
            group.groupConditionCount = Int64(groupCondition.count)
           return group
        }
    
    
    
    
    func saveMessage(dictPush: Any) -> MessageEntity
        {
            let ent = NSEntityDescription.entity(forEntityName: entityMessage , in: appDelegate().managedObjectContext)
            let message = MessageEntity(entity: ent!, insertInto: appDelegate().managedObjectContext)
        if let messageContent = dictPush as?  Dictionary<String, Any>
        {
            let messageDict = messageContent["message"] as! Dictionary<String, Any>
             let senderDict = messageContent["sender_info"] as? Dictionary<String, Any>

            message.thread = getThreadEntity(dictComplete: messageContent)
            message.messageThreadID =   messageContent["thread_id"] as? String
            message.messageID = messageDict["id"] as? String
            message.messageContent = messageDict["message"] as? String
            message.messageDate = messageDateFormat.date(from: messageDict["datetime"] as! String) as NSDate?
            message.sender = createSenderEntity(dictUser: senderDict!)
        }
    
        appDelegate().saveContext()
            
            return message
    }
    
    
    
    func getSavedMessagesForThread(threadID : String) -> [MessageEntity]
    {
        
        var arrayMessage = [MessageEntity]()
        let request = createMessageFetchRequest()
        let predicate = NSPredicate(format: "messageThreadID == %@",threadID)
        request.predicate = predicate
        do {
            let list = try  appDelegate().managedObjectContext.fetch(request)
            if list.count > 0
            {
                arrayMessage.append(contentsOf: list)
                //adding to returning account list
            }
        }
        catch{
            print(error.localizedDescription)
        }
        return arrayMessage
    }
    
    
    
    
    
    
    
   /*
    func createAccount(dict : Dictionary<String,AnyObject>)
    {
        /*Create new account with all properties in core data(AccountInfo)*/
        let ent = NSEntityDescription.entity(forEntityName: entityNameAccount , in: appDelegate().managedObjectContext)
        //new object for AccountInfo created
        let account = AccountInfo(entity: ent!, insertInto: appDelegate().managedObjectContext)
        print(dict)
        //Assigning properties
        account.accountID =  Date.timestamp()
        account.accountName = dict["accountName"] as? String
        account.accountBalance = dict["accountBalance"] as! Double
        account.accountReconciled = dict["accountReconciled"] as! Double
        account.accountNotes =  dict["accountNotes"] as? String
        //final step to save the new reflection in core data
        appDelegate().saveContext()
    }
    
    func fetchAccountList()-> [AccountInfo]?
    {
        // returns account saved in core data
        var accountList = [AccountInfo]()
        // Returns AccountInfo fetch request
        let request = createAccountFetchRequest()
        //Sorting based on accountName
        let sortDesc = NSSortDescriptor.init(key: "accountName", ascending: true)
        request.sortDescriptors = [sortDesc]
        do {
            let list = try  appDelegate().managedObjectContext.fetch(request)
            if list.count > 0{
                //adding to returning account list
                accountList.append(contentsOf: list)
                return accountList
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        //array with fetched accounts
        return accountList
    }
    
    
    
    func searchAccount (strName : String) -> AccountInfo
    {
        
        var account : AccountInfo? = nil
        let request = createAccountFetchRequest()
        let predicate = NSPredicate(format: "accountName == %@",strName)
        request.predicate = predicate
        do {
            let list = try appDelegate().managedObjectContext.fetch(request)
            if list.count > 0{
                account = list[0]
            }else{
              return self.createImportedAccount(strName: strName)
            }
      }
            
    catch{
        
    print(error.localizedDescription)
        
   }
        return account!
}
    
    
    
    func createImportedAccount(strName : String) -> AccountInfo
    {
        let ent = NSEntityDescription.entity(forEntityName: entityNameAccount , in: appDelegate().managedObjectContext)
        //new object for AccountInfo created
        let account = AccountInfo(entity: ent!, insertInto: appDelegate().managedObjectContext)
        account.accountID =  Date.timestamp()
        account.accountName = strName
        account.accountBalance = 0.0
        account.accountReconciled = 0.0
        account.accountNotes = "Imported Account"
        appDelegate().saveContext()
        
        return account
        
    }




func deleteAccount(account : AccountInfo)
{
    // delete particular account
    do
    {
        appDelegate().managedObjectContext.delete(account)
        appDelegate().saveContext()
    }
    catch{
        print(error.localizedDescription)
        
    }
}



//MARK:- Transactions
//MARK:-


func fetchTransactionWithReconciledList(account : AccountInfo)-> [TransactionInfo]?
{
    //Returns array of transaction saved
    
    var accountList = [TransactionInfo]()
    let request = createTransactionFetchRequest()
    let predicate = NSPredicate(format: "account == %@",account)
    request.predicate = predicate
    let sortDesc = NSSortDescriptor.init(key: "transactionDate", ascending: false)
    request.sortDescriptors = [sortDesc]
    
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            accountList.append(contentsOf: list)
            return accountList
        }
    }
    catch{
        print(error.localizedDescription)
    }
    return accountList
}

func fetchTransactionWithOutReconciledList(account : AccountInfo)-> [TransactionInfo]?
{
    var accountList = [TransactionInfo]()
    let request = createTransactionFetchRequest()
    let predicate = NSPredicate(format: "account == %@ AND transactionReconciled == %@",   argumentArray: [account , false])
    request.predicate = predicate
    let sortDesc = NSSortDescriptor.init(key: "transactionDate", ascending: false)
    request.sortDescriptors = [sortDesc]
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            accountList.append(contentsOf: list)
            return accountList
        }
    }
    catch{
        print(error.localizedDescription)
        
    }
    return accountList
}



func fetchTransactionWithStartAndEndDate(account : AccountInfo , startDate : Date , endDate : Date) ->  [TransactionInfo]?
{
    var transactionList = [TransactionInfo]()
    let request = createTransactionFetchRequest()
    let predicate = NSPredicate(format: "account == %@ AND transactionDate >= %@ AND transactionDate <= %@",   argumentArray: [account , startDate ,endDate ])
    request.predicate = predicate
    let sortDesc = NSSortDescriptor.init(key: "transactionDate", ascending: true)
    request.sortDescriptors = [sortDesc]
    
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            
            print(list)
            transactionList.append(contentsOf: list)
            return transactionList
        }
    }
    catch{
        print(error.localizedDescription)
        
    }
    return transactionList
}


func searchTransactions(strSearch : String , account : AccountInfo) ->  [TransactionInfo]?
{
    var transactionList = [TransactionInfo]()
    let request = createTransactionFetchRequest()
    
    if strSearch.characters.count > 0 {
        let firstCharcter = NSString(string: strSearch).substring(to: 1)
        let charset = CharacterSet(charactersIn: "0123456789")
        
        if firstCharcter.rangeOfCharacter(from: charset.inverted) != nil{
            //"string Starts with alphabetically"
            let predicate = NSPredicate(format: "account == %@ AND transactionDescription BEGINSWITH[cd] %@",   argumentArray: [ account ,strSearch ])
            request.predicate = predicate
        }else{
            
            let predicate = NSPredicate(format: "account == %@ AND transactionAmountStr BEGINSWITH %@",   argumentArray: [ account ,strSearch ])
            request.predicate = predicate
        }
    }
    
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            
            print(list)
            transactionList.append(contentsOf: list)
            return transactionList
        }
    }
    catch{
        print(error.localizedDescription)
    }
    return transactionList
}




func fetchLastRecurringTransaction(mainRecTxn : RecurringTransactionInfo)-> TransactionInfo?
{
    let request = createTransactionFetchRequest()
    let predicate = NSPredicate(format: "transactionID == %@ && transactionIsRecurring == %@",  argumentArray: [ mainRecTxn.recurringID , true])
    request.predicate = predicate
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            print(list)
            return list[0]
            
        }
    }
    catch{
        print(error.localizedDescription)
        
    }
    return nil
}
   
    
    func createImportedTransaction(account : AccountInfo , dictInfo : Dictionary< String , Any>)
    {
        
        let ent = NSEntityDescription.entity(forEntityName: entityNameTransaction , in: appDelegate().managedObjectContext)
        let transaction = TransactionInfo(entity: ent!, insertInto: appDelegate().managedObjectContext)
        

        
        let transactionType  = dictInfo["transactionType"] as! String
        transaction.transactionID =  Date.timestamp()
        transaction.transactionIsRecurring =  false
        transaction.transactionDate  =  dictInfo["transactionDate"] as! NSDate?
        transaction.transactionCategory = dictInfo["transactionCategory"] as? String
        transaction.transactionCheck = dictInfo["transactionCheck"] as? String
        transaction.transactionDescription = dictInfo["transactionDescription"] as? String
        transaction.transactionMemo = dictInfo["transactionMemo"] as? String
        transaction.transactionAmount = dictInfo["transactionAmount"] as! Double
        transaction.transactionAmountStr = dictInfo["transactionAmountStr"] as? String

        
        let reconciledStatus = dictInfo["transactionReconciled"] as! String
       let previousBalance = account.accountBalance
        if transactionType == "Deposit"
        {
            transaction.transactionType = "Deposit"
            account.accountBalance = previousBalance + (dictInfo["transactionAmount"] as! Double)
            
        }else{
            
           account.accountBalance = previousBalance - (dictInfo["transactionAmount"] as! Double)
            transaction.transactionType = "Withdrawal"
        }
       

        if reconciledStatus == "YES"
        {
            transaction.transactionReconciled = true
            
            
            if transaction.transactionType == "Deposit"
            {
                account.accountReconciled = (account.accountReconciled) + (dictInfo["transactionAmount"] as! Double)
            }else{
                account.accountReconciled = (account.accountReconciled) - (dictInfo["transactionAmount"] as! Double)
            }
            
        }else{
            transaction.transactionReconciled = false
        }
        
         transaction.account = account
        appDelegate().saveContext()
    }


func deleteTransaction(transaction : TransactionInfo)
 {
    do
    {
        appDelegate().managedObjectContext.delete(transaction)
        appDelegate().saveContext()
    }
    catch{
        print(error.localizedDescription)
    }
}


//MARK:- Import Transaction and Account Creation
//MARK:-








//MARK:- Recurring Transactions
//MARK:-


func createRecurringTransaction(dict : Dictionary<String,Any>)
{
    let ent = NSEntityDescription.entity(forEntityName: entityNameRecurringTransaction , in: appDelegate().managedObjectContext)
    let transaction = RecurringTransactionInfo(entity: ent!, insertInto: appDelegate().managedObjectContext)
    transaction.recurringAmount = dict["recurringAmount"] as! Double
    transaction.recurringCategory = dict["recurringCategory"] as? String
    transaction.recurringDescription = dict["recurringDescription"] as? String
    transaction.recurringMemo = dict["recurringMemo"] as? String
    transaction.recurringTransactionType = dict["recurringTransactionType"] as? String
    transaction.recurringType = Int16(dict["recurringType"] as! Int)
    transaction.recurringDay = Int16(dict["recurringDay"] as! Int)
    transaction.accountAssociated = dict["accountAssociated"] as? AccountInfo
    transaction.recurringActive = dict["recurringActive"] as! Bool
    transaction.recurringStartDate = dict["recurringStartdate"] as? String
    transaction.recurringID = Date.timestamp()
    transaction.recurringFinalStartDate = (dict["recurringStartdate"] as? String)!.getDateFromString() as NSDate?
    transaction.recurringLastUpdate = Date() as NSDate?

    appDelegate().saveContext()
    
    
}



    func fetchRecurringTransactionList()-> [RecurringTransactionInfo]?
    {
        var accountList = [RecurringTransactionInfo]()
        let request = createRecurringTransactionFetchRequest()
        // To fetch
       // let predicate = NSPredicate(format: "recurringActive == %@ AND recurringFinalStartDate <= %@",   argumentArray: [true , date])
       // request.predicate = predicate
        do {
            let list = try  appDelegate().managedObjectContext.fetch(request)
            if list.count > 0{
                accountList.append(contentsOf: list)
                return accountList
            }
        }
        catch{
            
        }
        return accountList
    }



    func fetchRecurringTransactionList(date : Date , Type : Int)-> [RecurringTransactionInfo]?
{
    var accountList = [RecurringTransactionInfo]()
    let request = createRecurringTransactionFetchRequest()
    // To fetch
     let predicate = NSPredicate(format: "recurringActive == %@ AND recurringFinalStartDate <= %@ AND recurringType == %d",   argumentArray: [true , date , Type])
    
     request.predicate = predicate
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            accountList.append(contentsOf: list)
            return accountList
        }
    }
    catch{
        
    }
    return accountList
}


func fetchRecurringTransactionList(account : AccountInfo)-> [RecurringTransactionInfo]?
{
    var accountList = [RecurringTransactionInfo]()
    let request = createRecurringTransactionFetchRequest()
    let predicate = NSPredicate(format: "accountAssociated == %@",account)
    request.predicate = predicate
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            accountList.append(contentsOf: list)
            return accountList
        }
    }
    catch{
        
    }
    return accountList
}






func deleteRecurringTransaction(transaction : RecurringTransactionInfo)
{
    do
    {
        appDelegate().managedObjectContext.delete(transaction)
        appDelegate().saveContext()
    }
    catch{
        
    }
}


//MARK:- Security
//MARK:-

func saveSecuritySettings(dict : Dictionary<String,Any> )
{
    
    let ent = NSEntityDescription.entity(forEntityName: entitySecurity , in: appDelegate().managedObjectContext)
    let security = Security(entity: ent!, insertInto: appDelegate().managedObjectContext)
    
    security.securityPin = dict["securityPin"] as? String
    security.securityActive = dict["securityActive"] as! Bool
    security.securityQuestion = dict["securityQuestion"] as? String
    security.securityAnswer = dict["securityAnswer"] as? String
    appDelegate().saveContext()
    //entitySecurity
}


func getSecuritySettings() -> Security?
{
    
    let request = createSecurityFetchRequest()
    do {
        let list = try  appDelegate().managedObjectContext.fetch(request)
        if list.count > 0{
            return list[0]
        }
    }
    catch{
        
    }
    return nil
}




//MARK:- Fetch requests
//MARK:-

func createSecurityFetchRequest()-> NSFetchRequest<Security>
{
    let request: NSFetchRequest<Security>
    if #available(iOS 10.0, *) {
        request = Security.fetchRequest()
    } else {
        request = NSFetchRequest(entityName: entitySecurity)
    }
    request.entity = NSEntityDescription.entity(forEntityName: entitySecurity, in: appDelegate().managedObjectContext)
    return request
}



func createRecurringTransactionFetchRequest()-> NSFetchRequest<RecurringTransactionInfo>
{
    let request: NSFetchRequest<RecurringTransactionInfo>
    if #available(iOS 10.0, *) {
        request = RecurringTransactionInfo.fetchRequest()
    } else {
        request = NSFetchRequest(entityName: entityNameRecurringTransaction)
    }
    request.entity = NSEntityDescription.entity(forEntityName: entityNameRecurringTransaction, in: appDelegate().managedObjectContext)
    return request
}


 */



func createMessageFetchRequest()-> NSFetchRequest<MessageEntity>
{
    let request: NSFetchRequest<MessageEntity>
    if #available(iOS 10.0, *) {
        request = MessageEntity.fetchRequest()
    } else {
        request = NSFetchRequest(entityName: entityMessage)
    }
    
    request.entity = NSEntityDescription.entity(forEntityName: entityMessage, in: appDelegate().managedObjectContext)
    return request
}

func createThreadFetchRequest()-> NSFetchRequest<ThreadEntity>
{
    let request: NSFetchRequest<ThreadEntity>
    if #available(iOS 10.0, *) {
        request = ThreadEntity.fetchRequest()
    } else {
        request = NSFetchRequest(entityName: entityThread)
    }
    request.entity = NSEntityDescription.entity(forEntityName: entityThread, in: appDelegate().managedObjectContext)
    return request
}







}
