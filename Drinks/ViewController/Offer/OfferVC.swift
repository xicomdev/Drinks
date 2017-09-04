//
//  OfferVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum OfferEnabled : Int
{
    case BeOffered = 1
    case Offered = 2
}



class OfferVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet weak var lblNoOfferFound: UILabel!
    @IBOutlet weak var imgViewNoOffer: UIImageView!
    var selectedOption : OfferEnabled = .BeOffered

    @IBOutlet weak var btnOffered: UIButton!
    @IBOutlet weak var btnBeOffered: UIButton!
    @IBOutlet weak var tblGroups: UITableView!

    
    @IBOutlet weak var viewNavigation: UIView!
    
    var arrayBeOffered : [Group] = [Group]()
    var arrayOffered : [Group] = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewNavigation.cornerRadius(value: 17.5)
        btnBeOffered.cornerRadius(value: 17.5)
        btnOffered.cornerRadius(value: 17.5)
        
        if selectedOption == .BeOffered{
            btnBeOffered.backgroundColor = APP_BlueColor
            btnBeOffered.isSelected = true

        }else{
            btnOffered.backgroundColor = APP_BlueColor
            btnOffered.isSelected = true

        }
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        tblGroups.registerNibsForCells(arryNib: ["OfferGroupCell"])
        tblGroups.delegate = self
        tblGroups.dataSource = self
        self.getBeOfferedGroups()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionBtnOptionChanged(_ sender: UIButton) {
        
        if sender == btnBeOffered{
            selectedOption = .BeOffered
            btnBeOffered.backgroundColor = APP_BlueColor
            btnBeOffered.isSelected = true
            btnOffered.backgroundColor = APP_GrayColor
            btnOffered.isSelected = false
            self.getBeOfferedGroups()

        }else{
            
            selectedOption = .Offered
            
            btnBeOffered.backgroundColor = APP_GrayColor
            btnBeOffered.isSelected = false
            btnOffered.backgroundColor = APP_BlueColor
            btnOffered.isSelected = true
            self.getOfferedGroups()
        }
        self.tblGroups.reloadData()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if selectedOption == .BeOffered{
            self.getBeOfferedGroups()
            
        }else{
            self.getOfferedGroups()
            
        }

    }
    
    
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if selectedOption == .BeOffered
         {
            return arrayBeOffered.count
        }else{
            return arrayOffered.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenWidth + 107
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedOption == .BeOffered{
           
                let cell = tableView.dequeueReusableCell(withIdentifier:"OfferGroupCell") as! OfferGroupCell
                cell.assignData(groupInfo: arrayBeOffered[indexPath.row])
                cell.callbackAction = { (group : Group) in
                GroupManager.setGroup(group: group)
                GroupManager.sharedInstance.sendInterest(handler: { (isSuccess, group, error) in
                    if isSuccess
                    {
                        if let groupInfo = group as? Group
                        {
                            let index =  Group.getIndex(arrayGroups: self.arrayBeOffered, group: groupInfo)
                            cell.group  = groupInfo
                            cell.assignData(groupInfo: groupInfo)
                            self.arrayBeOffered[index] = groupInfo
                            self.tblGroups.reloadData()
                        }
                    }else
                    {
                        showAlert(title: "Drinks", message: error!, controller: self)
                    }
                })
            }

             //   cell.viewBottomLine.isHidden = false
                 return cell
        }else{
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier:"OfferGroupCell") as! OfferGroupCell
            
            cell.assignData(groupInfo: arrayOffered[indexPath.row])
            cell.callbackAction = { (group : Group) in
                GroupManager.setGroup(group: group)
                GroupManager.sharedInstance.sendInterest(handler: { (isSuccess, group, error) in
                    if isSuccess
                    {
                        if let groupInfo = group as? Group
                        {
                            let index =  Group.getIndex(arrayGroups: self.arrayOffered, group: groupInfo)
                            cell.group  = groupInfo
                            cell.assignData(groupInfo: groupInfo)
                            self.arrayOffered[index] = groupInfo
                            self.tblGroups.reloadData()
                            
                            
                            
                        }
                    }else
                    {
                        showAlert(title: "Drinks", message: error!, controller: self)
                    }
                })
            }

                       return cell
        }
     
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedOption == .BeOffered
        {
            
            let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
            groupVC.groupInfo = arrayBeOffered[indexPath.row]
            self.navigationController?.pushViewController(groupVC, animated: true)
        }else{
            let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
            groupVC.groupInfo = arrayOffered[indexPath.row]
            self.navigationController?.pushViewController(groupVC, animated: true)

            
        }
    }
    

    //MARK:- API Methods
    //MARK:-

    func getBeOfferedGroups()
    {
        

        GroupManager.sharedInstance.getBeOfferedGroup { (isSuccess, response, strError) in
            
            if isSuccess{
                
                if let groups = response as? [Group]
                {
                    self.arrayBeOffered.removeAll()
                    self.arrayBeOffered = groups
                    self.tblGroups.reloadData()
                    
                    if self.arrayBeOffered.count == 0 {
                        self.imgViewNoOffer.isHidden = false
                        self.lblNoOfferFound.isHidden = false
                        self.tblGroups.isHidden = true

                    }else{
                        
                        self.imgViewNoOffer.isHidden = true
                        self.lblNoOfferFound.isHidden = true
                        self.tblGroups.isHidden = false

                    }

                    
                }
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
        
    }
    
    func getOfferedGroups()
    {
        GroupManager.sharedInstance.getSentOfferedGroup { (isSuccess, response, strError) in
            if isSuccess
            {
                if let groups = response as? [Group]
                {
                    self.arrayOffered.removeAll()
                    self.arrayOffered = groups
                    self.tblGroups.reloadData()
                    
                    
                    if self.arrayOffered.count == 0 {
                        self.imgViewNoOffer.isHidden = false
                        self.lblNoOfferFound.isHidden = false
                        self.tblGroups.isHidden = true
                        
                        

                    }else{
                        self.imgViewNoOffer.isHidden = true
                        self.lblNoOfferFound.isHidden = true
                        self.tblGroups.isHidden = false

                    }
                }
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }

    
    
  
}
