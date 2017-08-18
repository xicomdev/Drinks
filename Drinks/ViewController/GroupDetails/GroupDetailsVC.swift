//
//  GroupDetailsVC.swift
//  Drinks
//
//  Created by maninder on 8/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GroupDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblGroupDetail: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tblGroupDetail.registerNibsForCells(arryNib: ["GroupImageCell" , "DescriptionCell" ,"InfoCell" , "GroupLocationCell" , "GroupOwnerCell", "GroupConditionCell"])
        tblGroupDetail.delegate = self
        tblGroupDetail.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 4
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
            
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupImageCell") as! GroupImageCell
                cell.callbackAction = {(action : GroupAction ) in
                    self.dismiss(animated: true, completion: nil)
                }
                return cell
                
            }else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"DescriptionCell") as! DescriptionCell
                return cell
            }else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupLocationCell") as! GroupLocationCell
                
                return cell
            }else if indexPath.row == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"InfoCell") as! InfoCell
                cell.showTopLabel()
                return cell
            }else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupOwnerCell") as! GroupOwnerCell
                return cell
            }
            
        }else{
            
        let cell = tableView.dequeueReusableCell(withIdentifier:"GroupConditionCell") as! GroupConditionCell
            return cell
                    
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
