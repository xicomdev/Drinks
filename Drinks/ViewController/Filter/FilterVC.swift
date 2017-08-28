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
    Age,
  //  LastLogin,
    NumberOfPeople,
    Job,
    Relation,
    Action
    
}


//let arrayDistance : [Int] = [10, 20, 30 , 40 , 50 , 100]
//
//let arrayAge : [String] = ["20 - 25", "26 - 30", "31 - 35" , "36 - 40" , "41 - 45"]
//let arrayRelations : [String] = ["Collegues","School Friends","College Friends","Family", "Open"]
//
//let arrayPeople : [Int] = [1, 2, 3 , 4 , 5 ]

struct FilterInfo {
    var distance : Int = -1
    var age : [String] = [String]()
    var relation : [String] = [String]()
    var people : [Int] = [Int]()
    var job : [Job] = [Job]()
    

}

class FilterVC: UIViewController,UITableViewDataSource,UITableViewDelegate,MSSelectionCallback {
    
    var filterDetails : FilterInfo = FilterInfo()
    
    var arrFilter : [String] = ["Place","Age","Number Of People" , "Job" , "Relation"]
    @IBOutlet weak var btnCancel: UIButton!
    
    var selectedOption : OptionEnabled = .Filter
    @IBOutlet weak var tblListing: UITableView!

    
    var filterDelegate : MSSelectionCallback? = nil
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
            
            self.filterDelegate?.replaceRecords!()
            
        }
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func actionBtnOptionChanged(_ sender: UIButton) {
        
        if sender == btnFilter{
            selectedOption = .Filter
            btnFilter.backgroundColor = APP_BlueColor
            btnFilter.isSelected = true
            btnSort.backgroundColor = APP_GaryColor
            btnSort.isSelected = false
            
        }else{
            selectedOption = .Sort

            btnFilter.backgroundColor = APP_GaryColor
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
        }else{
             return FilterListing.Action.rawValue 
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
                }else{
                    cell.lblSelected.text = ""
                }
                
                }else  if indexPath.row == 1
                    {
                         cell.lblSelected.text = getStringToDisplay(array: self.filterDetails.age, type: .Age)
                        
                    }else  if indexPath.row == 2
                    {
                        cell.lblSelected.text = getStringToDisplay(array: self.filterDetails.people, type: .NumberOfPeople)


                    }else  if indexPath.row == 3
                    {
                        cell.lblSelected.text = getStringToDisplay(array: self.filterDetails.job, type: .Job)


                    }else if indexPath.row == 4
                    {
                        cell.viewBottomLine.isHidden = true
                      cell.lblSelected.text = getStringToDisplay(array: self.filterDetails.relation, type: .Relation)
                    }
                    
            cell.lblOptionName.text = arrFilter[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:"FilterActionCell") as! FilterActionCell
            cell.callbackAction = { (action : GroupAction , data : Any?) in
                
                if action == .CANCEL
                {
                    self.filterDetails = FilterInfo()
                    self.tblListing.reloadData()
                }else if action == .FILTER
                {
                    
                    if appDelegate().appLocation != nil{
                        self.filterDelegate?.moveWithSelection!(selected: self.filterDetails)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        showAlert(title: "Drinks", message: "Please enable your location.", controller: self)
                    }
                    
                    
                }
                
            }
        return cell
        }else{
            if indexPath.row <= 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"FilterOptionCell") as! FilterOptionCell
                cell.viewBottomLine.isHidden = false
                if indexPath.row == 4{
                    cell.viewBottomLine.isHidden = true
                }
                cell.lblSelected.text = ""
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier:"FilterActionCell") as! FilterActionCell
            return cell

        }
     }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedOption == .Filter
        {
            let selectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionVC
            selectionVC.selectType = FilterListing(rawValue: indexPath.row)!
            selectionVC.filterDetails = filterDetails
            selectionVC.delegate = self
            self.navigationController?.pushViewController(selectionVC, animated: true)
        }
    }
    
    
       
    //MARK:- Custom Delegates
    //MARK:-
    func moveWithSelection(selected: Any) {
        
        if let filteredObj = selected as? FilterInfo
        {
            self.filterDetails = filteredObj
            self.tblListing.reloadData()
        }
        
    }
    
    
    //MARK:- Filter API
    //MARK:-
    
    
   // func getFilteredResults()


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
