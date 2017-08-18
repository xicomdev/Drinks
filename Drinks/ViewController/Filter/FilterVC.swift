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
    LastLogin,
    NumberOfPeople,
    Job,
    Relation
   
}


class FilterVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var selectedOption : OptionEnabled = .Filter
    @IBOutlet weak var tblListing: UITableView!

    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var btnSave: UIButton!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
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
             return FilterListing.Relation.rawValue + 1
        }else{
             return FilterListing.Relation.rawValue + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row <= 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"FilterOptionCell") as! FilterOptionCell
            cell.viewBottomLine.isHidden = false
            if indexPath.row == 5{
                cell.viewBottomLine.isHidden = true
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:"FilterActionCell") as! FilterActionCell
        return cell
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
