//
//  CreateGroupVC.swift
//  Drinks
//
//  Created by maninder on 8/11/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import CoreLocation

class CreateGroupVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MSGetImage,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource ,UITextFieldDelegate{
    @IBOutlet weak var tblCreateGroup: UITableView!

    
    var pickerCreated = UIPickerView()
    
    var pickerRelationShip  = UIPickerView()

    var textFieldSelected  : UITextField? = nil
    var cellSelected : GroupInfoCell? = nil
    var selectedIndex : Int = -1
    
    var viewFooter : GroupFooterView!
    var imageSelected : UIImage? = nil
    var tagEnabled = false
    var strDescription = "Enter description here"
    var relationship : String = ""
    
    let arrayRelations : [String] = ["Collegues","School Friends","College Friends","Family", "Open"]
    
    var arrayConditions : [GroupCondition] = [GroupCondition]()
    
    var arrayJobs  = [Job]()
    var arrayAges  : [Int] = [18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "CrossActive"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateGroupVC.actionBtnBackPressed))
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navTitle(title: "Create Group" as NSString, color: UIColor.black , font:  FontRegular(size: 18))

        
        let firstCondition = GroupCondition()
        self.arrayConditions.append(firstCondition)
        
        
        pickerRelationShip.delegate = self
        pickerRelationShip.dataSource = self
        
        pickerCreated.delegate = self
        pickerCreated.dataSource = self
        
        //var pickerCreated = UIPickerView()

        
//        pickerAges.delegate = self
//        pickerAges.dataSource = self
//        
//        pickerJob.delegate = self
//        pickerJob.dataSource = self
        
        
        arrayJobs = Job.getJobList()
        
        
        
        
        viewFooter = GroupFooterView.instanceFromNib(width: ScreenWidth, height: CGFloat(335))
        viewFooter.txtViewDescription.delegate = self
        viewFooter.txtViewDescription.text = "Enter description here"
        viewFooter.txtRelationship.inputView = pickerRelationShip
        viewFooter.txtRelationship.delegate = self
        
        viewFooter.callbackDone = {(done : GroupAction) in
            self.createNewGroup()
            
        }
        
        
        tblCreateGroup.tableFooterView = viewFooter
        tblCreateGroup.registerNibsForCells(arryNib: ["SelectPhotoVC" , "LocationCell" , "InfoCell" , "OwnerCell", "GroupInfoCell", "AddMoreCell"])
        tblCreateGroup.delegate = self
        tblCreateGroup.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    
    func actionBtnBackPressed()
    {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewGroup(){
        
        if imageSelected == nil
        {
            
            showAlert(title: "Drinks", message: "Please add image first.", controller: self)
            return
        }
        
        if arrayConditions[0].age == 0 || arrayConditions[0].occupation.ID == ""
        {
            showAlert(title: "Drinks", message: "Please enter group type values.", controller: self)
            return
            
        }
        
        
        if arrayConditions.count > 1{
            
            
            for i in 1 ..< arrayConditions.count {
                
                if arrayConditions[i].age == 0 || arrayConditions[i].occupation.ID == ""
                {
                    showAlert(title: "Drinks", message: "Please enter group type values.", controller: self)
                    return
                }
                
            }
        }
        
        
        if viewFooter.txtRelationship.text == ""
        {
            showAlert(title: "Drinks", message: "Please enter relationship for group.", controller: self)
            return
            
        }
        if viewFooter.txtViewDescription.text == ""
        {
            showAlert(title: "Drinks", message: "Please enter description for group.", controller: self)
            return
        }

        var imageArray = [MSImage]()
        
        if imageSelected != nil{
            
            let fileName = "Drinks\(self.timeStamp).jpeg"
            let model =  MSImage.init(file: imageSelected! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
        }
        
        Group.sharedInstance.createNewGroup(image: imageArray) { (isSuccess, response, strError) in
            
          //  if isSuccess{
            
            showAlert(title: "Drinks", message: "Group has been created successfully.", controller: self)
           //
           // }
          //  else{
                
          //  }
        
        }
    }
    
    
    //MARK:- TableView Delegate
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 4
        }else{
            return arrayConditions.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return ScreenWidth + CGFloat(10)
                //return screen
            }else if indexPath.row == 1
            {
                return 120
            }else if indexPath.row == 2
            {
                return 95
                
            }else
            {
                return 55
            }
        }else{
            
            if arrayConditions.count == indexPath.row {
                return 55
            }

            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"SelectPhotoVC") as! SelectPhotoVC
                cell.callbackImage = {(action : GroupAction ) in
                    self.openCustomCamera()
                }
                if imageSelected != nil{
                    cell.imgViewGroup.image = imageSelected
                    cell.updateUI(btnCheck: true)
                }else{
                    cell.updateUI(btnCheck: false)
                }
                
                return cell
                
            }else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"LocationCell") as! LocationCell
                cell.lblLocationName.text = appDelegate().myLocationName
                cell.callbackAction = {( action : GroupAction) in
                  if action == .LOCATION
                  {
                        self.tblCreateGroup.reloadData()
                  }else{
                        self.tagEnabled = !self.tagEnabled
                  }
                }
                if self.tagEnabled  == true
                {
                    cell.btnSelection.isSelected = true
                }else{
                    cell.btnSelection.isSelected = false
                }
                return cell
            }else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"InfoCell") as! InfoCell
                
                return cell
            }else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"OwnerCell") as! OwnerCell
                cell.setOwnerInfo()
                return cell
            }

        }else{
           
            if arrayConditions.count == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier:"AddMoreCell") as! AddMoreCell
                cell.callbackAddMore = {(action : GroupAction ) in
                    
                    if self.arrayConditions.count == 5{
                        showAlert(title: "Drinks", message: "Maximum limit reached.", controller: self)
                        return
                    }
                    let firstCondition = GroupCondition()
                    self.arrayConditions.append(firstCondition)
                    self.tblCreateGroup.reloadData()
                }
                return cell
                
            }else{
                
                    let cell = tableView.dequeueReusableCell(withIdentifier:"GroupInfoCell") as! GroupInfoCell
                    cell.callbackAction = { (action : GroupAction , test : Any?) in
                        
                        if action == .DELETE
                        {
                            let cell = test as! GroupInfoCell
                            let index = self.tblCreateGroup.indexPath(for: cell)
                            self.arrayConditions.remove(at: (index?.row)!)
                            self.tblCreateGroup.reloadData()
                            
                        }
                        
                    }
                cell.lblCounter.text = (indexPath.row + 1).description
                    cell.btnCancel.isHidden = false
                    cell.txtAge.delegate = self
                    cell.txtOccupation.delegate = self
                    cell.groupCond =  arrayConditions[indexPath.row]
                   if  indexPath.row == 0 {
                     cell.btnCancel.isHidden = true
                     }
                
                    cell.setNewValues()
                    return cell
                    
//                }else{
//                    
//                    
//                    let cell = tableView.dequeueReusableCell(withIdentifier:"GroupInfoCell") as! GroupInfoCell
//                       cell.conditionCount = indexPath.row
//                    cell.callbackAction = { (action : GroupAction , test : Any?) in
//                        
//                    }
//                    cell.lblCounter.text = (indexPath.row + 1).description
//                    cell.txtAge.tag = indexPath.row + 2
//                    cell.txtOccupation.tag = indexPath.row + 3
//                    return cell
//                }
              
            }
          
        }
    }
    
    //MARK:- TextView Delegates
    //MARK:-
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.checkIsEmpty() == true{
            textView.textColor = UIColor.gray
            textView.text = "Enter description here"
        }else{
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black

        if textView.text == "Enter description here"
        {
            textView.text  = ""
        }
    }
    
    //MARK:- TextField Delegates
    //MARK:-
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField !=  viewFooter.txtRelationship
        {
            
            let cell = textField.superview?.superview as! GroupInfoCell
            cellSelected = cell
            let selectedCondtion = cellSelected?.groupCond
            let ageArray = arrayAges.filter {
                ($0 == selectedCondtion?.age)
            }
            if ageArray.count > 0 {
                let index = arrayAges.index(of: ageArray[0])
                pickerCreated.selectRow(index!, inComponent: 0, animated: false)
            }else{
                
                pickerCreated.selectRow(0, inComponent: 0, animated: false)

            }
            
            let jobArray = arrayJobs.filter {
                ($0.ID ==  selectedCondtion?.occupation.ID)
            }
            if jobArray.count > 0 {
                let index = arrayJobs.index(of: jobArray[0])
                pickerCreated.selectRow(index!, inComponent: 1, animated: false)
            }else{
                pickerCreated.selectRow(0, inComponent: 1, animated: false)

            }
            textField.inputView = pickerCreated

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == viewFooter.txtRelationship{
        let seletedRelation = pickerRelationShip.selectedRow(inComponent: 0)
        viewFooter.txtRelationship.text = arrayRelations[seletedRelation]
      
        }else{
            
            
//            let pickerFirst =  cellSelected?.txtOccupation.inputView as! UIPickerView
//            let pickerSecond = cellSelected?.txtAge.inputView as! UIPickerView
//            
            let index = tblCreateGroup.indexPath(for: cellSelected!)
//            
            let firstRow = pickerCreated.selectedRow(inComponent: 0)
            let secondRow = pickerCreated.selectedRow(inComponent: 1)
         
            arrayConditions[(index?.row)!].age = arrayAges[firstRow]
            arrayConditions[(index?.row)!].occupation = arrayJobs[secondRow]
            self.tblCreateGroup.reloadData()
        }
    }
    
    //MARK:- UIPicker View Delegates
    //MARK:-
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerRelationShip {
              return arrayRelations.count
        }else {
            if component == 0 {
                return arrayAges.count
            }else{
                return arrayJobs.count
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerRelationShip {
              return 1
        }else{
            return 2
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerRelationShip {
            return arrayRelations[row]
        }else{
            if component == 0 {
                return arrayAges[row].description
            }else{
                return arrayJobs[row].engName
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerRelationShip{
            viewFooter.txtRelationship.text = arrayRelations[row]
        }else{
            
            if component == 0 {
                cellSelected?.txtAge.text = arrayAges[row].description
             //   return arrayAges[row].description
            }else{
                cellSelected?.txtOccupation.text = arrayJobs[row].engName
             ///   return arrayJobs[row].engName
            }
        }
    }

    

    
    
    
    //MARK:- Select Photo
    //MARK:-
    func openCustomCamera(){
        
        let camera =  msCameraStoryBoard.instantiateViewController(withIdentifier: "MSCameraGallery") as! MSCameraGallery
        camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }
    
    //MARK:- MSCamera Selection Delegate
    //MARK:-
    
    func moveWithSelectedImage(selected: Any) {
        if selected is UIImage{
            self.imageSelected = selected as? UIImage
            self.tblCreateGroup.reloadData()
        }
    }
    
    
    

}
