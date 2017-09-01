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
            btnOffered.backgroundColor = APP_GaryColor
            btnOffered.isSelected = false
            
        }else{
            
            selectedOption = .Offered
            
            btnBeOffered.backgroundColor = APP_GaryColor
            btnBeOffered.isSelected = false
            btnOffered.backgroundColor = APP_BlueColor
            btnOffered.isSelected = true
        }
        self.tblGroups.reloadData()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if selectedOption == .BeOffered{
            return 10
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenWidth + 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedOption == .BeOffered{
           
                let cell = tableView.dequeueReusableCell(withIdentifier:"OfferGroupCell") as! OfferGroupCell
            
             //   cell.viewBottomLine.isHidden = false
                 return cell
        }else{
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier:"OfferGroupCell") as! OfferGroupCell
                       return cell
        }
     
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if selectedOption == .Filter
//        {
//            let selectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionVC
//            selectionVC.selectType = FilterListing(rawValue: indexPath.row)!
//            selectionVC.filterDetails = filterDetails
//            selectionVC.delegate = self
//            self.navigationController?.pushViewController(selectionVC, animated: true)
//        }
    }
    

    //MARK:- API Methods
    //MARK:-

    func getBeOfferedGroups()
    {
        
        
    }
    
    func getOfferedGroups()
    {
        
        
    }

    
    
  
}
