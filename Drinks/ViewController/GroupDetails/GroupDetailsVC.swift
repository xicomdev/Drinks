//
//  GroupDetailsVC.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum PushType : Int {
    
    case Home = 0
    case BeOffered = 1
    case Offered = 2
    
}

class GroupDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MSProtocolCallback,MSSelectionCallback {
    @IBOutlet weak var tblGroupDetail: UITableView!
    
    var groupImage : UIImage? = nil
    var delegateDetail : MSProtocolCallback? = nil
    var groupInfo : Group!
    
    var groupAction : PushType = .Home
    
    var groupChanged = false
    var interestSent = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        tblGroupDetail.registerNibsForCells(arryNib: ["GroupImageCell" , "DescriptionCell" ,"InfoCell" , "GroupLocationCell" , "GroupOwnerCell", "GroupConditionCell"])
        tblGroupDetail.delegate = self
        tblGroupDetail.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        if interestSent {
            interestSent = false
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func actionOptions(_ sender: Any) {
        
        if self.groupInfo.groupBy == .Other
        {
            
            
            actionSheet(btnArray: [NSLocalizedString("Report", comment: "")], cancel: true, destructive: 0, controller: self, handler: { (isSuccess, index) in
                if isSuccess
                {
                    let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportGroupVC") as! ReportGroupVC
                    reportVC.group = self.groupInfo
                    reportVC.delegate = self
                    self.navigationController?.pushViewController(reportVC, animated: true)
                    
                }
            })
        }else
        {
            let cell = tblGroupDetail.cellForRow(at: IndexPath(row: 0, section: 0)) as! GroupImageCell
            
            self.groupImage = cell.imgViewGroup.image
            actionSheet(btnArray: [NSLocalizedString("Edit", comment: ""), NSLocalizedString("Delete", comment: "")], cancel: true, destructive: 1, controller: self, handler: { (isSuccess, index) in
                if isSuccess
                {
                    if index == 0 {
                        let createGroupVC =  self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
                        createGroupVC.delegate = self
                        createGroupVC.group = self.groupInfo
                        createGroupVC.imageSelected = self.groupImage
                        createGroupVC.classAction = .Editing
                        
                        let navigation = UINavigationController(rootViewController: createGroupVC)
                        self.navigationController?.present(navigation, animated: true, completion: nil)
                        
                    }else
                    {
                        
                        self.deleteGroup()
                    }
                    
                }
            })
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.groupAnyActionPerformed()
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.navigationController?.popViewController(animated: true)
            
        })
    }
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 5
        }else{
            if groupInfo.groupConditions.count > 0 {
                if groupInfo.groupConditions[0].age == 0 && groupInfo.groupConditions[0].occupation.engName == "" {
                    return 0
                }else {
                    return groupInfo.groupConditions.count
                }
            }else {
                return 0
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return ScreenWidth + CGFloat(20)
                //return screen
            }else if indexPath.row == 1
            {
                if groupInfo.groupDescription == "" {
                    return 0
                }else  {
                    return 70
                }
            }else if indexPath.row == 2
            {
                return 75
            }else if indexPath.row == 3
            {
                return 45
            }else{
                return 55
            }
            
        }else{
            
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupImageCell") as! GroupImageCell
                if self.groupAction == .BeOffered {
                    cell.imgvwGradient.isHidden = false
                    cell.lblOfferedFrom.text = NSLocalizedString("Offered from ", comment: "") + groupInfo.groupOwner.fullName
                }else if self.groupAction == .Offered {
                    cell.imgvwGradient.isHidden = false
                    cell.imgvwGradient.image = nil
                    cell.lblOfferedFrom.text = NSLocalizedString("I just want to drink it", comment: "")
                }else {
                    cell.imgvwGradient.isHidden = true
                    cell.lblOfferedFrom.isHidden = true
                }
                cell.callBackVC = {(action : GroupAction , image : Any ) in
                    if action == .BACK
                    {
                        
                        
                        self.groupAnyActionPerformed()
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                        self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                    }else if action == .OPTION  {
                        
                        if self.groupInfo.groupBy == .Other
                        {
                            
                            
                            actionSheet(btnArray: [NSLocalizedString("Report", comment: "")], cancel: true, destructive: 0, controller: self, handler: { (isSuccess, index) in
                                if isSuccess
                                {
                                        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportGroupVC") as! ReportGroupVC
                                        reportVC.group = self.groupInfo
                                        reportVC.delegate = self
                                        self.navigationController?.pushViewController(reportVC, animated: true)
                                    
                                }
                            })
                        }else
                        {
                            
                            self.groupImage = image as? UIImage
                            actionSheet(btnArray: [NSLocalizedString("Edit", comment: ""), NSLocalizedString("Delete", comment: "")], cancel: true, destructive: 1, controller: self, handler: { (isSuccess, index) in
                                if isSuccess
                                {
                                    if index == 0 {
                                        let createGroupVC =  self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
                                        createGroupVC.delegate = self
                                        createGroupVC.group = self.groupInfo
                                        createGroupVC.imageSelected = self.groupImage
                                        createGroupVC.classAction = .Editing
                                        
                                        let navigation = UINavigationController(rootViewController: createGroupVC)
                                        self.navigationController?.present(navigation, animated: true, completion: nil)
                                        
                                    }else
                                    {
                                        
                                        self.deleteGroup()
                                    }
                                    
                                }
                            })
                        }
                        
                    }else if action == .ACCEPT{
                        
                        GroupManager.setGroup(group: self.groupInfo)
                        
                        
                        if self.groupAction == .Home
                        {
                        GroupManager.sharedInstance.sendOrRemoveInterest(handler: { (isSuccess, group, error) in
                            if isSuccess
                            {
                                if let groupInfo = group as? Group
                                {
                                    self.groupInfo = groupInfo
                                    self.tblGroupDetail.reloadData()
                                    //self.groupChanged = true
                                    if  self.groupInfo.drinkedStatus == .Drinked{
                                        showInterestedAlert(controller: self)
                                        self.interestSent = true
                                    }
                                }
                            }else
                            {
                                showAlert(title: "Drinks", message: error!, controller: self)
                            }
                        })
                            
                            
                            
                        }else if self.groupAction == .BeOffered {
                            self.acceptBeOfferedGroupInterest()
                            
                        }else{
                            
                         // self.actionForOfferedGroupDetails()
                            
                        }
                    }
                }
                cell.setCellInfo(groupDetail: groupInfo)
                return cell
                
            }else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"DescriptionCell") as! DescriptionCell
                cell.assignGroupInfo(group: groupInfo)
                return cell
            }else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupLocationCell") as! GroupLocationCell
                cell.setCellInfo(groupDetail: groupInfo)
                
                return cell
            }else if indexPath.row == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"InfoCell") as! InfoCell
                cell.lblRelation.text = NSLocalizedString("Today's Members", comment: "")
                cell.showTopLabel()
                return cell
            }else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupOwnerCell") as! GroupOwnerCell
                cell.assignData(groupInfo: groupInfo)
                return cell
            }
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"GroupConditionCell") as! GroupConditionCell
            
            cell.assignData(condition: groupInfo.groupConditions[indexPath.row] , counter : indexPath.row)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            if indexPath.row == 4 {
                let ownerVC =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileGroupOwnerVC") as! ProfileGroupOwnerVC
                ownerVC.ownerUser = groupInfo.groupOwner
                self.navigationController?.pushViewController(ownerVC, animated: true)
            }
        }
    }
    
    
    
    
    func deleteGroup(){
        
        groupInfo.deleteGroup { (success, response, strError) in
            if success
            {
                if self.delegateDetail != nil
                {
                    self.delegateDetail?.updateData!()
                    
                }
                self.navigationController?.popViewController(animated: true)
                
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }

    
    
    //MARK:- MSSelectionDelegate 
    //MARK:-
    
    
    
    func replaceRecords(obj: Any) {
        
        
    if let groupUpdated = obj as? Group
    {
        groupInfo = groupUpdated
        self.tblGroupDetail.reloadData()
        groupChanged = true
     }
        
    }
    
    
    
//    @objc optional func moveWithSelection(selected : Any)
//    @objc optional func actionPreviousVC(action: Bool )
//    @objc optional func replaceRecords(obj : Any )
//    @objc optional func replaceRecords()
//    
//    @objc optional func moveRecordsWithType(obj : AnyObject , type : String )
    
    
    
    
    //MARK:- MSProtocolCallback Delegates
    //MARK:-
    
    func actionMoveToPreviousVC()
    {
        self.perform(#selector(GroupDetailsVC.showReportAlert), with: nil, afterDelay: 0.4)
        
    }
    
    
    func showReportAlert(){
        
        let reportAlertVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportedGroupAlertVC") as! ReportedGroupAlertVC
        reportAlertVC.view.alpha = 0
        self.present(reportAlertVC, animated: false, completion: nil)
    }
    
    
    
    
    
    
    func groupAnyActionPerformed(){
        
//        if groupChanged == true{
//            if self.delegateDetail != nil{
//                self.delegateDetail?.replaceGroup!(obj: self.groupInfo)
//            }
//            
//        }
    }
    
    
    
    
    
    
    //MARK:- BEOffered and Offered Action
    //MARK:-
    
    
//    fileprivate  func showAcceptOrRejectAlert(){
//        
//        if groupInfo.drinkedStatus == .Waiting
//        {
//            
//            MSAlert(message: "Do you want to accept it?", firstBtn: "Reject", SecondBtn: "Accept", controller: self, handler: { (success, index) in
//                if index == 1{
//                    self.acceptBeOfferedGroupInterest()
//                }else{
//                    self.rejectBeOfferedGroupInterest()
//                }
//                
//            })
//            
//            
//        }else if groupInfo.drinkedStatus == .Confirmed{
//            
//            MSAlert(message: "Do you want to reject it?", firstBtn: "No", SecondBtn: "Yes", controller: self, handler: { (success, index) in
//                if index == 1{
//                    self.rejectBeOfferedGroupInterest()
//                }
//                
//            })
//            
//        }
//    }

    
    
    func actionForOfferedGroupDetails(){
        
        
        MSAlert(message: "Do you want to cancel it?", firstBtn: "No", SecondBtn: "Yes", controller: self, handler: { (success, index) in
            if index == 1
            {
                
                GroupManager.sharedInstance.sendOrRemoveInterest(handler: { (isSuccess, response, strError) in
                    if isSuccess
                    {
                        if let groupInfo = response as? Group
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else
                    {
                        showAlert(title: "Drinks", message: strError!, controller: self)
                    }
                })
            }
        })
        
    }
    
    
    
    
    func acceptBeOfferedGroupInterest()
    {
        GroupManager.sharedInstance.acceptInterest(handler: { (isSuccess, response, strError) in
            if isSuccess
            {
                if let groupInfo = response as? Group
                {
                    self.groupInfo = groupInfo
                    self.tblGroupDetail.reloadData()
                }
            }else
            {
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        })
        
        
        
    }
    
//    func rejectBeOfferedGroupInterest()
//    {
//        GroupManager.sharedInstance.removeInterest(handler: { (isSuccess, response, strError) in
//            if isSuccess
//            {
//                if let groupInfo = response as? Group
//                {
//                    self.tblGroupDetail.reloadData()
//                    self.navigationController?.popViewController(animated: true)
//                    
//                }
//            }else
//            {
//                showAlert(title: "Drinks", message: strError!, controller: self)
//            }
//        })
//        
//    }
    

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
