//
//  FilterVC.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit


enum OptionEnabled : Int
{
    case Filter = 1
    case Sort = 2
}


enum FilterListing : Int
{
    case Place = 0,
    Age,
   // LastLogin,
    NumberOfPeople,
    Job,
    Relation,
    Action
   
}

enum SortListing : Int
{
    case Place = 0,
    Offers,
    Age,
    LastLogin

}

//let arrayDistance : [Int] = [10, 20, 30 , 40 , 50 , 100]
//
//let arrayAge : [String] = ["20 - 25", "26 - 30", "31 - 35" , "36 - 40" , "41 - 45"]
//let arrayRelations : [String] = ["Collegues","School Friends","College Friends","Family", "Open"]
//
//let arrayPeople : [Int] = [1, 2, 3 , 4 , 5 ]

struct FilterInfo {
    var filterEnabled = false
    var filterLocationName : GroupLocation? = nil
    var distance : Int = -1
    var age : [String] = [String]()
    var relation : [String] = [String]()
    var people : [Int] = [Int]()
    var job : [Job] = [Job]()

}

struct SortInfo {
    var sortEnabled = false
    var filterLocationName : GroupLocation? = nil
    var Place :String = String()
    var age :String = String()
    var LastLogin :String = String()
    var Offers :String = String()
    
}
class FilterVC: UIViewController,UITableViewDataSource,UITableViewDelegate,MSSelectionCallback {
    
    var filterDetails = FilterInfo()
    var sortDetails = SortInfo()
    
    var arrFilter : [String] = ["Place","Age","Number Of People" , "Job" , "Relation"]
    var arrSort = ["Place",  "Offers", "Age","Last Login"]
    @IBOutlet weak var btnCancel: UIButton!
    
    var selectedOption : OptionEnabled = .Filter
    @IBOutlet weak var tblListing: UITableView!

    
    var selectionDelegate : MSSelectionCallback? = nil
    var filterDelegate : FilterCallback? = nil
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        viewNavigation.cornerRadius(value: 17.5)
        btnSort.cornerRadius(value: 17.5)
        btnFilter.cornerRadius(value: 17.5)
        
        
        
        if selectedOption == .Filter{
            btnFilter.backgroundColor = APP_BlueColor
            btnFilter.isSelected = true
        }else{
            btnSort.backgroundColor = APP_BlueColor
            btnSort.isSelected = true
        }
        tblListing.registerNibsForCells(arryNib: ["FilterOptionCell" , "FilterActionCell"])
        tblListing.delegate = self
        tblListing.dataSource = self
        
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
  
    
    @IBAction func actionBtnCancelPressed(_ sender: Any) {
        
        if filterDetails.distance == -1 && filterDetails.age.count == 0 && filterDetails.relation.count == 0 && filterDetails.people.count == 0
            && filterDetails.job.count == 0 {
            
            self.selectionDelegate?.replaceRecords!()
            
        }
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func actionBtnOptionChanged(_ sender: UIButton) {
        
        if sender == btnFilter{
            selectedOption = .Filter
            btnFilter.backgroundColor = APP_BlueColor
            btnFilter.isSelected = true
            btnSort.backgroundColor = APP_GrayColor
            btnSort.isSelected = false
            
        }else{
            selectedOption = .Sort
            btnFilter.backgroundColor = APP_GrayColor
            btnFilter.isSelected = false
            btnSort.backgroundColor = APP_BlueColor
            btnSort.isSelected = true
        }
        self.tblListing.reloadData()
        
    }
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedOption == .Filter{
             return FilterListing.Action.rawValue + 1
        }else if selectedOption == .Sort{
            return arrSort.count + 1
        }else{
             return FilterListing.Action.rawValue  + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedOption == .Filter{
            if indexPath.row <= 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"FilterOptionCell") as! FilterOptionCell
                cell.viewBottomLine.isHidden = false
                if indexPath.row == 0 {
                    if self.filterDetails.distance != -1 {
                            
                        cell.lblSelected.text = self.filterDetails.distance.description + " KM"
                    }
                    else{
                        cell.lblSelected.text = ""
                    }
                    
                }else  if indexPath.row == 1
                {
                    cell.lblSelected.text = NSLocalizedString(getStringToDisplay(array: self.filterDetails.age, type: .Age), comment: "")
                    
                }else  if indexPath.row == 2
                {
                    cell.lblSelected.text = NSLocalizedString(getStringToDisplay(array: self.filterDetails.people, type: .NumberOfPeople), comment: "")
                    
                }else  if indexPath.row == 3
                {
                    cell.lblSelected.text = NSLocalizedString(getStringToDisplay(array: self.filterDetails.job, type: .Job), comment: "")
                    
                }else if indexPath.row == 4
                {
                    cell.viewBottomLine.isHidden = true
                    cell.lblSelected.text = NSLocalizedString(getStringToDisplay(array: self.filterDetails.relation, type: .Relation), comment: "")
                }
                
                cell.lblOptionName.text = NSLocalizedString(arrFilter[indexPath.row], comment: "")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier:"FilterActionCell") as! FilterActionCell
            cell.callbackAction = { (action : GroupAction , data : Any?) in
                
                if action == .CANCEL
                {
                    self.filterDetails = FilterInfo()
                    self.sortDetails = SortInfo()
                    self.tblListing.reloadData()
                }else if action == .FILTER
                {
                    
                    if appDelegate().appLocation != nil{
                        
                        self.moveBack()
                    }else{
                        showAlert(title: "Drinks", message: NSLocalizedString("Please enable your location.", comment: ""), controller: self)
                    }
                }
            }
            return cell
        }else{
            if indexPath.row < 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"FilterOptionCell") as! FilterOptionCell
                cell.viewBottomLine.isHidden = false
                if indexPath.row == 0 {
                    
                    cell.lblSelected.text = NSLocalizedString(self.sortDetails.Place, comment: "")
                    
                }else  if indexPath.row == 1
                {
                    cell.lblSelected.text = NSLocalizedString(self.sortDetails.Offers, comment: "")

                }else  if indexPath.row == 2
                {
                    cell.lblSelected.text = NSLocalizedString(self.sortDetails.age, comment: "")

                }else  if indexPath.row == 3
                {
                    cell.lblSelected.text = NSLocalizedString(self.sortDetails.LastLogin, comment: "")

                }
                cell.lblOptionName.text = NSLocalizedString(arrSort[indexPath.row], comment: "")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier:"FilterActionCell") as! FilterActionCell
            cell.callbackAction = { (action : GroupAction , data : Any?) in
                
                if action == .CANCEL
                {
                    self.filterDetails = FilterInfo()
                    self.sortDetails = SortInfo()
                    self.tblListing.reloadData()
                }else if action == .FILTER
                {
                    
                    if appDelegate().appLocation != nil{
                        
                        self.moveBack()
                    }else{
                        showAlert(title: "Drinks", message: NSLocalizedString("Please enable your location.", comment: ""), controller: self)
                    }
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedOption == .Filter
        {
            let selectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionVC
            selectionVC.selectType = FilterListing(rawValue: indexPath.row)!
            selectionVC.filterDetails = filterDetails
            selectionVC.selectedOption = selectedOption
            selectionVC.delegate = self
            self.navigationController?.pushViewController(selectionVC, animated: true)
        }else if selectedOption == .Sort
        {
            let selectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionVC
            selectionVC.sortType = SortListing(rawValue: indexPath.row)!
            selectionVC.sortDetails = sortDetails
            selectionVC.selectedOption = selectedOption
            selectionVC.delegate = self
            self.navigationController?.pushViewController(selectionVC, animated: true)
        }
    }
    
    func moveBack() {
        
        self.filterDetails.filterEnabled = true
        self.sortDetails.sortEnabled = true
        self.filterDelegate?.moveWithSelectionFilter(filterInfo: filterDetails, sortInfo: sortDetails)
        self.dismiss(animated: true, completion: nil)
        
    }
       
    //MARK:- Custom Delegates
    //MARK:-
    func moveWithSelection(selected: Any) {
        
        if let filteredObj = selected as? FilterInfo
        {
            self.filterDetails = filteredObj
            self.tblListing.reloadData()
        }else if let filteredObj = selected as? SortInfo
        {
            self.sortDetails = filteredObj
            self.tblListing.reloadData()
        }
    }
    
    //MARK:- Filter API
    //MARK:-
    
   // func getFilteredResults()


}
