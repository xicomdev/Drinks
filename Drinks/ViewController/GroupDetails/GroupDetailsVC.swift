//
//  GroupDetailsVC.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MSProtocolCallback,MSSelectionCallback {
    @IBOutlet weak var tblGroupDetail: UITableView!
    
    var groupImage : UIImage? = nil
    var delegateDetail : MSProtocolCallback? = nil
    var groupInfo : Group!
    
    var groupChanged = false
    
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
            return groupInfo.groupConditions.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return ScreenWidth + CGFloat(20)
                //return screen
            }else if indexPath.row == 1
            {
                return 70
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
            
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupImageCell") as! GroupImageCell
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
                            
                            
                            actionSheet(btnArray: ["Report"], cancel: true, destructive: 0, controller: self, handler: { (isSuccess, index) in
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
                            actionSheet(btnArray: ["Edit" , "Delete"], cancel: true, destructive: 1, controller: self, handler: { (isSuccess, index) in
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
                                    
                                }else{
                                    
                                }
                            })
                        }
                        
                    }else if action == .ACCEPT{
                        
                        GroupManager.setGroup(group: self.groupInfo)
                        GroupManager.sharedInstance.sendInterest(handler: { (isSuccess, group, error) in
                            if isSuccess
                            {
                                if let groupInfo = group as? Group
                                {
                                    self.groupInfo = groupInfo
                                    self.tblGroupDetail.reloadData()
                                    showInterestedAlert(controller: self)
                                    self.groupChanged = true
                                }
                            }else
                            {
                                showAlert(title: "Drinks", message: error!, controller: self)
                            }
                        })
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
        
        if groupChanged == true{
            if self.delegateDetail != nil{
                self.delegateDetail?.replaceGroup!(obj: self.groupInfo)
            }
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
