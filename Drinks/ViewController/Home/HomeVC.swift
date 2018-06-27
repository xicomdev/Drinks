//
//  HomeVC.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Firebase
class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MSSelectionCallback,MSProtocolCallback , FilterCallback {
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var imgViewNotice: UIImageView!
    @IBOutlet weak var vwRecruitWait: UIView!
    
    var globalFilter = FilterInfo()
    var globalSort = SortInfo()
    
    @IBOutlet var viewPreviewConstraint: NSLayoutConstraint!
    
    var arrayGroups = [Group]()
    
    
    var myGroups = [Group]()
    
    var timer = Timer()
    
    @IBOutlet weak var btnCreateGroup: UIButton!
    @IBOutlet var collectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewGroup: UICollectionView!
    
    var isFromNoRecruit = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        let btnRightBar:UIBarButtonItem =  UIBarButtonItem.init(image:UIImage(named: "FilterOption"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeVC.actionBtnDonePressed))
        
        self.navigationItem.rightBarButtonItem = btnRightBar
        self.navTitle(title: NSLocalizedString("Search", comment: "") as NSString , color: UIColor.black , font:  FontRegular(size: 17))
        
        
//        let nibHeader = UINib(nibName: "MyGroupsHeader", bundle: nil)
//    
//        collectionViewGroup.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "MyGroupsHeader")
        
      
        let nib = UINib(nibName: "GroupCell", bundle: nil)
        collectionViewGroup.register(nib, forCellWithReuseIdentifier: "GroupCell")
        collectionViewGroup.delegate = self
        collectionViewGroup.dataSource = self
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)

        LoginManager.sharedInstance.getUserDetail{ (success, response, strError) in
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        FBManager.sharedInstance.getFriendList()
        Analytics.logEvent(AnalyticsEventSearch, parameters: nil)
        self.navigationController?.isNavigationBarHidden = false
        if !isFromNoRecruit {
           
                if globalFilter.filterEnabled == false{
                    
                    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callGroupsApi), userInfo: nil, repeats: true)
                }
            
            
        }
        isFromNoRecruit = false
       

    }

    func callGroupsApi() {
        if appDelegate().appLocation != nil {
            self.getGroups()
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionBtnDonePressed()
    {
        let filterVC =  self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.filterDelegate = self
        filterVC.selectionDelegate = self
        filterVC.sortDetails = globalSort
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
    
    @IBAction func actionBtnMyPostedGroup(_ sender: UIButton) {
        
        if self.myGroups.count > 0 {
                            let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
                            groupVC.groupInfo = self.myGroups[0]
                            groupVC.delegateDetail = self
                            self.navigationController?.pushViewController(groupVC, animated: true)
        }
    }
    //MARK:- CollectionView Delegate Methods
    //MARK:-
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//        
//        if myGroups.count > 0 {
//            return CGSize(width: collectionViewGroup.frame.size.width , height: 50)
//        }else{
//            
//            return CGSize(width: collectionViewGroup.frame.size.width , height: 0)
//
//        }
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyGroupsHeader", for: indexPath) as! MyGroupsHeader
//       
//        header.callbackBtn = {
//            if self.myGroups.count > 0 {
//                let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
//                groupVC.groupInfo = self.myGroups[0]
//                groupVC.delegateDetail = self
//                self.navigationController?.pushViewController(groupVC, animated: true)
//            }
//        }
//        return header
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.assignData(groupInfo: arrayGroups[indexPath.row])
        cell.callbackAction = { (group : Group) in
            GroupManager.setGroup(group: group)
            if LoginManager.getMe.myCredits == "0" {
                showAlert(title: "Drinks", message: NSLocalizedString("You don't have enough tickets to make interest", comment: ""), controller: self)
            }else {
                GroupManager.sharedInstance.sendOrRemoveInterest(handler: { (isSuccess, group, error) in
                    if isSuccess
                    {
                        if let groupInfo = group as? Group
                        {
                            cell.group  = groupInfo
                            cell.assignData(groupInfo: groupInfo)
                            let index =  Group.getIndex(arrayGroups: self.arrayGroups, group: groupInfo)
                            self.arrayGroups[index] = groupInfo
                            self.collectionViewGroup.reloadData()
                            if groupInfo.drinkedStatus == .Drinked{
                                showInterestedAlert(controller: self)
                            }
                        }
                    }else
                    {
                        if error! == "Group not exist" || error! == "グループが存在しない" {
                            let alert = UIAlertController(title: "Drinks", message: error!, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                                self.callGroupsApi()
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }else if error! == "You have already been offered interest by this group" || error! == "あなたはすでにこのグループの関心を得ています" {
                            let alert = UIAlertController(title: "Drinks", message: error!, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                                let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                                tabBarController.selectedIndex = 1
                                appDelegate().window?.rootViewController = tabBarController
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }else {
                            self.isFromNoRecruit = true
                            let noGroupVc = mainStoryBoard.instantiateViewController(withIdentifier: "NoRecruitVC") as! NoRecruitVC
                            noGroupVc.delegate = self
                            self.present(noGroupVc, animated: true, completion: nil)
                        }
                        
                    }
                })
            }
        }
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        groupVC.delegateDetail = self
        groupVC.groupAction = .Home
        self.navigationController?.pushViewController(groupVC, animated: true)
        
    }
    
    //MARK:- Get Groups
    //MARK:-
    
    func getGroups()
    {
        Group.getGroupListing { (isSuccess, response, strError) in
            if isSuccess
            {
                if let dictGroups = response as? Dictionary<String,Any>
                {
                    
                    let myGroups = dictGroups["MyGroups"] as! [Group]
                    let AllGroups = dictGroups["OtherGroups"] as! [Group]
                    
                    self.myGroups.removeAll()
                    self.myGroups.append(contentsOf: myGroups)
                    
                    self.arrayGroups.removeAll()
                    self.arrayGroups = AllGroups
                    self.collectionViewGroup.reloadData()
                   // self.updateCollectionInsects()

                    
                    self.updatePreviewView()
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
        Group.getFilteredGroupListing(filterInfo: globalFilter, sortInfo: globalSort) { (isSuccess, response, strError) in
            if isSuccess
            {
                if let dictGroups = response as? Dictionary<String,Any>
                {
                    
                    let myGroups = dictGroups["MyGroups"] as! [Group]
                    let AllGroups = dictGroups["OtherGroups"] as! [Group]
                    
                    self.myGroups.removeAll()
                    self.myGroups.append(contentsOf: myGroups)
                    
                    self.arrayGroups.removeAll()
                    self.arrayGroups = AllGroups
                    self.collectionViewGroup.reloadData()
                    // self.updateCollectionInsects()
                    
                    
                    self.updatePreviewView()
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
    
//    func getSortedRecords(){
//        Group.getSortedGroupListing(sortInfo: globalSort) { (isSuccess, response, strError) in
//            if isSuccess
//            {
//
//                self.myGroups.removeAll()
//                self.arrayGroups.removeAll()
//
//                if let arrayNewGroups = response as? [Group]
//                {
//                    self.arrayGroups = arrayNewGroups
//                }
//                self.collectionViewGroup.reloadData()
//
//                if self.arrayGroups.count > 0 {
//                    self.collectionViewGroup.isHidden = false
//                    self.lblNotice.isHidden = true
//                    self.imgViewNotice.isHidden = true
//                }else{
//                    self.collectionViewGroup.isHidden = true
//                    self.lblNotice.isHidden = false
//                    self.imgViewNotice.isHidden = false
//                }
//            } else
//            {
//                showAlert(title: "Drinks", message: strError!, controller: self)
//            }
//        }
//
//    }
    
    //MARK:- Custom Delegates
    //MARK":-
    
    func moveHomeToAddNew(_ reload: Bool) {
        if reload {
            self.callGroupsApi()
        }else {
            let createGroupVC =  self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
            createGroupVC.delegate = self
            let navigation = UINavigationController(rootViewController: createGroupVC)
            self.navigationController?.present(navigation, animated: true, completion: nil)
        }
        
    }
    
//    func moveWithSelection(selected: Any) {
//
//        if let filteredObj = selected as? FilterInfo
//        {
//
//        }else if let filteredObj = selected as? SortInfo {
//            globalSort = filteredObj
//            self.getSortedRecords()
//        }
//
//    }
    
    func moveWithSelectionFilter(filterInfo: FilterInfo, sortInfo: SortInfo) {
        globalFilter = filterInfo
        globalSort = sortInfo
        self.getFilteredRecords()
    }
    
    func replaceRecords()
    {
        globalFilter = FilterInfo()
        self.getGroups()
        
    }
    
    
    func updateData() {
      //  self.getGroups()

    }
    
   
    
    func replaceGroup(obj: Any) {
        
        if let groupObj = obj as? Group
        {
            let index =  Group.getIndex(arrayGroups: self.arrayGroups, group: groupObj)
            self.arrayGroups[index] = groupObj
            self.collectionViewGroup.reloadData()
        }
    }
    
    func updatePreviewView(){
        
        if self.myGroups.count > 0 {
            self.viewPreviewConstraint.constant = 50
            btnCreateGroup.isHidden = true
            vwRecruitWait.isHidden = true
        }else{
            self.viewPreviewConstraint.constant = 0
            btnCreateGroup.isHidden = false
            vwRecruitWait.isHidden = false
        }
        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }

    }


}
