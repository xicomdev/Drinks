//
//  HomeVC.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MSSelectionCallback {
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var imgViewNotice: UIImageView!

    var globalFilter = FilterInfo()
    var arrayGroups = [Group]()
    @IBOutlet weak var btnCreateGroup: UIButton!
    @IBOutlet var collectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewGroup: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black

        self.navigationItem.hidesBackButton = true
        let btnRightBar:UIBarButtonItem =  UIBarButtonItem.init(image:UIImage(named: "FilterOption"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeVC.actionBtnDonePressed))
        
        self.navigationItem.rightBarButtonItem = btnRightBar
        self.navTitle(title:"Search" , color: UIColor.black , font:  FontRegular(size: 17))
        
        
        
      
        self.view.backgroundColor = UIColor.groupTableViewBackground
        let nib = UINib(nibName: "GroupCell", bundle: nil)
        collectionViewGroup.register(nib, forCellWithReuseIdentifier: "GroupCell")
        collectionViewGroup.delegate = self
        collectionViewGroup.dataSource = self
        collectionViewGroup.backgroundColor = UIColor.groupTableViewBackground

        self.getGroups()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionBtnDonePressed()
    {
        let filterVC =  self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.filterDelegate = self
        filterVC.filterDetails = globalFilter
        let navigation = UINavigationController(rootViewController: filterVC)
        self.navigationController?.present(navigation, animated: true, completion: nil)
    }
    
    @IBAction func actionBtnCreateGroup(_ sender: UIButton) {
        let createGroupVC =  self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        createGroupVC.delegate = self
        let navigation = UINavigationController(rootViewController: createGroupVC)
        self.navigationController?.present(navigation, animated: true, completion: nil)
        
    }
    
    //MARK:- CollectionView Delegate Methods
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGroups.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.assignData(groupInfo: arrayGroups[indexPath.row])
        cell.callbackAction = { (group : Group) in
            GroupManager.setGroup(group: group)
            GroupManager.sharedInstance.sendInterest(handler: { (isSuccess, group, error) in
                if isSuccess
                {
                    if let groupInfo = group as? Group
                    {
                      let index =  Group.getIndex(arrayGroups: self.arrayGroups, group: groupInfo)
                        cell.group  = groupInfo
                        cell.assignData(groupInfo: groupInfo)
                        self.arrayGroups[index] = groupInfo
                        self.collectionViewGroup.reloadData()
                    }
                }else
                {
                    showAlert(title: "Drinks", message: error!, controller: self)
                }
            })
        }
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.collectionViewGroup.bounds.width, height: 5)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = CGSize(width: ((collectionViewGroup.frame.width - 5)/2), height: collectionViewGroup.frame.width/2 + 90)
        return size
        
    }
    
 
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
        groupVC.groupInfo = arrayGroups[indexPath.row]
        self.navigationController?.pushViewController(groupVC, animated: true)
        
    }
    
    //MARK:- Get Groups
    //MARK:-
    
    
    
    
    func getGroups()
    {
      
        Group.getGroupListing { (isSuccess, response, strError) in
            if isSuccess
            {
                if let arrayNewGroups = response as? [Group]
                {
                    self.arrayGroups.removeAll()
                    self.arrayGroups = arrayNewGroups
                    self.collectionViewGroup.reloadData()
                }
                
                if self.arrayGroups.count > 0 {
                    self.collectionViewGroup.isHidden = false
                    self.lblNotice.isHidden = true
                    self.imgViewNotice.isHidden = true
                }else{
                    self.collectionViewGroup.isHidden = true
                    self.lblNotice.isHidden = false
                    self.imgViewNotice.isHidden = false
                }
            } else
            {
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
    func getFilteredRecords(){
         Group.getFilteredGroupListing(filterInfo: globalFilter) { (isSuccess, response, strError) in
            if isSuccess
            {
                if let arrayNewGroups = response as? [Group]
                {
                    self.arrayGroups.removeAll()
                    self.arrayGroups = arrayNewGroups
                    self.collectionViewGroup.reloadData()
                }
                
                if self.arrayGroups.count > 0 {
                    self.collectionViewGroup.isHidden = false
                    self.lblNotice.isHidden = true
                    self.imgViewNotice.isHidden = true
                }else{
                    self.collectionViewGroup.isHidden = true
                    self.lblNotice.isHidden = false
                    self.imgViewNotice.isHidden = false
                }
            } else
            {
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }

        
    }
    //MARK:- Custom Delegates
    //MARK":-
    
    
    func moveWithSelection(selected: Any) {
        
        if let filteredObj = selected as? FilterInfo
        {
            globalFilter = filteredObj
            self.getFilteredRecords()
        }
        
    }
    
    func replaceRecords()
    {
        globalFilter = FilterInfo()
        self.getGroups()
        
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
