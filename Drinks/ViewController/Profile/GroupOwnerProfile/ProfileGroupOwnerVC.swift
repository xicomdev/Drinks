//
//  ProfileGroupOwnerVC.swift
//  Drinks
//
//  Created by maninder on 8/18/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ProfileGroupOwnerVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tblProfile: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "CrossActive"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectionVC.actionBtnBackPressed))
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navTitle(title: "Mani (27)", color: .black, font: FontRegular(size: 18))
        
        tblProfile.registerNibsForCells(arryNib: ["ProfileGroupOwnerCell" , "OwnerInfoCell" ])
        tblProfile.delegate = self
        tblProfile.dataSource = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func actionBtnBackPressed(){
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
            if indexPath.row == 0 {
                return ScreenWidth / 1.7
            }
                return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"ProfileGroupOwnerCell") as! ProfileGroupOwnerCell
                cell.setCornerRadius()
                               return cell
                
            }
        let cell = tableView.dequeueReusableCell(withIdentifier:"OwnerInfoCell") as! OwnerInfoCell
         return cell

        
        }
        
}
