//
//  SelectionVC.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum SelectionType : String{
    case Occupation = "Occupation"
    case Blood = "Blood"
    case Marriage = "Marriage"
    case Tabacco = "Tabacco"
    case School = "School"
    case Income = "Income"


}


class SelectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblListing: UITableView!
    var strHeaderTitle  = "Select Occupation"
    var arrayListing = [Any]()
    
    var selectedJob = Job()
    var selectedValue = String()
    
    var delegate : MSSelectionCallback? = nil
    var selectType : SelectionType = SelectionType.Occupation

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
       
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectionVC.actionBtnBackPressed))
        
     //   let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectionVC.actionBtnDonePressed))
        
      //  self.navigationItem.rightBarButtonItem = btnRightBar
        self.navigationItem.leftBarButtonItem = btnLeftBar
       

        
        
        tblListing.registerNibsForCells(arryNib: ["ListingCell"])
        
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblListing.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        tblListing.delegate = self
        tblListing.dataSource = self
        

        
        var strTitle = String()
        if selectType == .Occupation
        {
            arrayListing = Job.getJobList()
            strTitle = "Occupation"
            
        }else if selectType == .Blood
        {
            arrayListing = arrayBlood
            strTitle = "Blood type"
            strHeaderTitle = "Select blood type"


        }else if selectType == .Marriage
        {
            arrayListing = arrayMarriage
            strTitle = "Marriage History"
            strHeaderTitle = "Select marriage option"


        }else if selectType == .Tabacco
        {
            arrayListing = arrayToabacco
            strTitle = "Tabbaco"
            strHeaderTitle = "Select tabacco option"
            
        }else if  selectType == .School
        {
            arrayListing = arraySchool
            strTitle = "School Career"
            strHeaderTitle = "Select school career"

            
        }else if  selectType == .Income
        {
           arrayListing = arrayIncome
            strTitle = "Income"
            strHeaderTitle = "Select income option."

        }
        
        self.navTitle(title: NSLocalizedString(strTitle, comment: "") as NSString, color: UIColor.black , font:  FontRegular(size: 19))


        // Do any additional setup after loading the view.
    }
    
    
       
    func actionBtnDonePressed()
    {
        if selectType == .Occupation
        {
            
            if selectedJob.ID == ""
            {
                showAlert(title: "Drinks", message: NSLocalizedString("Please select one occupation first.", comment: ""), controller: self)
                return
            }
            if delegate != nil{
                self.delegate?.moveWithSelection!(selected: selectedJob)
            }
            
            
        }else{

            if selectedValue == ""
            {
                showAlert(title: "Drinks", message: NSLocalizedString("Please select one option first.", comment: ""), controller: self)
                return
                
            }
            if delegate != nil{
                self.delegate?.moveWithSelection!(selected: selectedValue)
            }
        }
        
       _ = self.navigationController?.popViewController(animated: true)
    }

    
    func actionBtnBackPressed()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 57
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView : SelectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
        headerView.lblHeader.text = NSLocalizedString(strHeaderTitle, comment: "")
   
        return headerView
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayListing.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ListingCell") as! ListingCell
        
        if selectType == .Occupation{
            
           let objJob = arrayListing[indexPath.row] as! Job
            cell.lblName.text = objJob.engName
            
            if selectedJob.ID == objJob.ID
            {
                cell.imgViewSelection.isHidden = false
            }else{
                cell.imgViewSelection.isHidden = true
            }
            
        }else{
            cell.lblName.text = NSLocalizedString((arrayListing[indexPath.row] as? String)!, comment: "")
            
            if selectedValue == arrayListing[indexPath.row] as? String
            {
                cell.imgViewSelection.isHidden = false
            }else{
                cell.imgViewSelection.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if selectType == .Occupation{
            
            let objJob = arrayListing[indexPath.row] as! Job
            
            if selectedJob.ID != objJob.ID
            {
                selectedJob = objJob
            }
            
        }else{
            let strSelecting = arrayListing[indexPath.row] as? String
            
            if selectedValue != arrayListing[indexPath.row] as? String
            {
              selectedValue   = strSelecting!
                
                
            }
        }
        
        self.actionBtnDonePressed()

        
//        if isFromSideMenu == false
//        {
//            
//            if KiteManager.getKite.inmate != nil{
//                if  KiteManager.getKite.inmate?.recipientID == arrInmates[indexPath.row].recipientID{
//                    KiteManager.getKite.inmate  = nil
//                }else{
//                    KiteManager.getKite.inmate = arrInmates[indexPath.row]
//                }
//            }else{
//                KiteManager.getKite.inmate = arrInmates[indexPath.row]
//            }
//            self.recipientTbl.reloadData()
//            
//        }
        
        self.tblListing.reloadData()
    }

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
