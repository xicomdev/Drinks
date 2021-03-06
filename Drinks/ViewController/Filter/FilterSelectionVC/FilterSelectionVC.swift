//
//  FilterSelectionVC.swift
//  Drinks
//
//  Created by maninder on 8/28/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class FilterSelectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MSSelectionCallback {

    
    
    @IBOutlet var tblListing: UITableView!
    var strHeaderTitle  = "Place"
    var arrayListing = [Any]()
    
    
    var delegate : MSSelectionCallback? = nil
    var selectType : FilterListing = FilterListing.Place
    var filterDetails : FilterInfo = FilterInfo()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectionVC.actionBtnBackPressed))
        
        let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectionVC.actionBtnDonePressed))
        
        self.navigationItem.rightBarButtonItem = btnRightBar
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        
        
        
        tblListing.registerNibsForCells(arryNib: ["ListingCell"])
        
        let nibHeader = UINib(nibName: "SelectionHeader", bundle: nil)
        tblListing.register(nibHeader, forHeaderFooterViewReuseIdentifier: "SelectionHeader")
        tblListing.delegate = self
        tblListing.dataSource = self
        
        
        
        var strTitle = String()
        if selectType == .Place
        {
            arrayListing = arrayDistance
            strTitle = "Place"
            strHeaderTitle = "Select place option"
            
            if filterDetails.filterLocationName == nil && appDelegate().appLocation != nil{
                filterDetails.filterLocationName = appDelegate().appLocation
            }

            
        }else if selectType == .NumberOfPeople
        {
            arrayListing = arrayPeople
            strTitle = "No. of people"
            strHeaderTitle = "Select people option"
            
            
        }else if selectType == .Job
        {
            arrayListing = Job.getJobList()
            strTitle = "Job"
            strHeaderTitle = "Select job option"
            
            
        }else if selectType == .Age
        {
            arrayListing = arrayAge
            strTitle = "Age"
            strHeaderTitle = "Select age range"
            
        }else if  selectType == .Relation
        {
            arrayListing = arrayRelations
            strTitle = "Relationship"
            strHeaderTitle = "Select Relationship"
            
            
        }else
        {
            arrayListing = arrayIncome
            strTitle = "Income"
            strHeaderTitle = "Select income option."
            
        }
        
        self.navTitle(title: strTitle as NSString, color: UIColor.black , font:  FontRegular(size: 19))
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func actionBtnDonePressed()
    {
        
        if selectType == .Place
        {
//            if filterDetails.distance == -1{
//                showAlert(title: "Drinks", message: "Please select place option.", controller: self)
//                return
//            }
            
            
        }else if selectType == .NumberOfPeople
        {
//            if filterDetails.people.count == 0{
//                showAlert(title: "Drinks", message: "Please select people option.", controller: self)
//                return
//            }
            
            
        }else if selectType == .Job
        {
//            if filterDetails.job.count == 0{
//                showAlert(title: "Drinks", message: "Please select job option.", controller: self)
//                return
//            }
            
        }else if selectType == .Age
        {
//            if filterDetails.age.count == 0{
//                showAlert(title: "Drinks", message: "Please select age option.", controller: self)
//                return
//            }
            
        }else if  selectType == .Relation
        {
//            if filterDetails.relation.count == 0{
//                showAlert(title: "Drinks", message: "Please select relationship option.", controller: self)
//                return
//            }
        }
        
        if delegate != nil{
            self.delegate?.moveWithSelection!(selected: filterDetails)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func actionBtnBackPressed()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if selectType == .Place{
            return 2
        }
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 57
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if selectType == .Place{
         
            if section == 1 {
                let headerView : SelectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
                headerView.lblHeader.text = "Location name"
                headerView.backgroundColor = .red
                return headerView
            }
        }
        let headerView : SelectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionHeader") as! SelectionHeader
        headerView.lblHeader.text = strHeaderTitle
        headerView.backgroundColor = .red
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectType == .Place{
            
            if section == 1 {
               return 1
            }
        }
        return arrayListing.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ListingCell") as! ListingCell
        
        if selectType == .Job{
            let objJob = arrayListing[indexPath.row] as! Job
            cell.lblName.text = objJob.engName
            if self.checkJobSelected(job: objJob)
            {
                cell.imgViewSelection.isHidden = false
            }else{
                cell.imgViewSelection.isHidden = true
            }
            
        }else{
            
            
            
            if indexPath.section == 1 && selectType == .Place{
                cell.lblName.text =  self.filterDetails.filterLocationName?.LocationName
               cell.imgViewSelection.isHidden = true
                return cell
            }
            
            cell.lblName.text = String(describing: arrayListing[indexPath.row])
           if self.checkAlreadySelected(info: arrayListing[indexPath.row])
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
        
        if selectType == .Job{
            let objJob = arrayListing[indexPath.row] as! Job
            if self.checkJobSelected(job: objJob) == false
            {
                self.filterDetails.job.append(objJob)
            }else{
                
                let selectedArray = filterDetails.job
                if selectedArray.count > 0
                {
                    let jobSelected = selectedArray.filter {
                        ($0.ID == objJob.ID)
                    }
                    if jobSelected.count > 0
                    {
                        let index = selectedArray.index(of: jobSelected[0] )
                        self.filterDetails.job.remove(at: index!)
                    }
                 }
            }

            
        }else{
            if selectType == .Place
            {
                
                if indexPath.section == 1 && selectType == .Place
                {
                    
                     let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                    mapVC.selectedFiltered = self.filterDetails
                    mapVC.returningDelegate = self
                   self.navigationController?.pushViewController(mapVC, animated: true)
                    
                    
                }
                
                if self.checkAlreadySelected(info: arrayListing[indexPath.row]) == false
                {
                    self.filterDetails.distance = arrayListing[indexPath.row] as! Int

                }else{
                    self.filterDetails.distance = -1
                }
                

            }else if selectType == .NumberOfPeople
            {
                if self.checkAlreadySelected(info: arrayListing[indexPath.row]) == false
                {
                    self.filterDetails.people.append(arrayListing[indexPath.row] as! Int)

                    
                }else{
                    let index = self.filterDetails.people.index(of: arrayListing[indexPath.row] as! Int)
                    self.filterDetails.people.remove(at: index!)
                }
                
            }else if selectType == .Age
            {
                
                if self.checkAlreadySelected(info: arrayListing[indexPath.row]) == false
                {
                    self.filterDetails.age.append(arrayListing[indexPath.row] as! String)
                    
                    
                }else{
                    let index = self.filterDetails.age.index(of: arrayListing[indexPath.row] as! String)
                        self.filterDetails.age.remove(at: index!)
                }
                
            }else if  selectType == .Relation
            {
                if self.checkAlreadySelected(info: arrayListing[indexPath.row]) == false
                {
                    self.filterDetails.relation.append(arrayListing[indexPath.row] as! String)
                    
                    
                }else{
                    let index = self.filterDetails.relation.index(of: arrayListing[indexPath.row] as! String)
                    if self.filterDetails.relation.count >= index! {
                        self.filterDetails.relation.remove(at: index!)
                    }

                }

            }
            
            }
     
        self.tblListing.reloadData()
    }
    
    
    func checkJobSelected(job : Job) -> Bool
    {
        
        let selectedArray = filterDetails.job
        if selectedArray.count > 0 {
            let jobSelected = selectedArray.filter {
                ($0.ID == job.ID)
            }
            if jobSelected.count > 0 {
              return true
            }else{
               return false
            }
        }else{
            return false
        }
    }
    
    func  checkAlreadySelected(info : Any) -> Bool
    {
        
        if selectType == .Place
        {
            if info as! Int == filterDetails.distance
            {
                return true
            }else{
               return false
            }
            
        }else if selectType == .NumberOfPeople
        {
            let selectedArray = filterDetails.people
            if selectedArray.count > 0 {
                let jobSelected = selectedArray.filter {
                    ($0 == (info as! Int))
                }
                if jobSelected.count > 0 {
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }

            
        }else if selectType == .Age
        {
            let selectedArray = filterDetails.age
            if selectedArray.count > 0 {
                let jobSelected = selectedArray.filter {
                    ($0 == (info as! String))
                }
                if jobSelected.count > 0 {
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }

            
        }else if  selectType == .Relation
        {
            let selectedArray = filterDetails.relation
            if selectedArray.count > 0 {
                let jobSelected = selectedArray.filter {
                    ($0 == (info as! String))
                }
                if jobSelected.count > 0 {
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
        
        return false

    }
    
    
    
    func moveWithSelection(selected: Any) {
        if let filterInfo = selected as? FilterInfo
        {
            self.filterDetails = filterInfo
            self.tblListing.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
