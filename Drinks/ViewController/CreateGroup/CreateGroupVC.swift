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

    
    var classAction : GroupActionType = .Creating
    
    var group = Group()
    
 //   var pickerCreated = UIPickerView()
    var pickerAgeSelection = UIPickerView()

    var pickerOccpuation = UIPickerView()

    
    var pickerRelationShip  = UIPickerView()

    var textFieldSelected  : UITextField? = nil
    var cellSelected : GroupInfoCell? = nil
    var selectedIndex : Int = -1
    var delegate : MSSelectionCallback? = nil
    var viewFooter : GroupFooterView!
    var imageSelected : UIImage? = nil
    var tagEnabled = false
    var strDescription = NSLocalizedString("We are drinking by three people, let's drink together! We are waiting for an offer!", comment: "")
    var relationship : String = ""
    
    var refreshLocationTimer : Timer!
  //  var group.groupConditions : [GroupCondition] = [GroupCondition]()
    
    var arrayJobs  = [Job]()
    var arrayAges  : [Int] = [20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55]
    
    var UserDp = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "CrossActive"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateGroupVC.actionBtnBackPressed))
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        
        viewFooter = GroupFooterView.instanceFromNib(width: ScreenWidth, height: CGFloat(335))
        viewFooter.txtViewDescription.delegate = self
        viewFooter.txtViewDescription.text = NSLocalizedString("We are drinking by three people, let's drink together! We are waiting for an offer!", comment: "")
        viewFooter.txtRelationship.inputView = pickerRelationShip
        viewFooter.txtRelationship.delegate = self
        viewFooter.txtRelationship.placeholder = NSLocalizedString("Select relationship with members", comment: "")
        UserDp.sd_setImage(with: URL(string: LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)

        viewFooter.callbackDone = {(done : GroupAction) in
          //  self.createNewGroup()
            
        }
        
        
        if  classAction == .Editing{
            
            self.navTitle(title: NSLocalizedString("Edit Group", comment: "") as NSString, color: UIColor.black , font:  FontRegular(size: 17))
            self.tagEnabled = group.tagEnabled
            viewFooter.txtViewDescription.text = group.groupDescription
            viewFooter.txtViewDescription.textColor = .black
            viewFooter.txtRelationship.text = group.relationship
            
          
        }else{
            self.navTitle(title: NSLocalizedString("Create Group", comment: "") as NSString, color: UIColor.black , font:  FontRegular(size: 17))
            let firstCondition = GroupCondition()
            group.groupConditions.append(firstCondition)
            
        }

        
     
       // self.arrayConditions.append(firstCondition)
        
        
        pickerRelationShip.delegate = self
        pickerRelationShip.dataSource = self
        
     
        
        pickerAgeSelection.delegate = self
        pickerAgeSelection.dataSource = self
        pickerOccpuation.delegate = self
        pickerOccpuation.dataSource = self
        
        arrayJobs = Job.getJobList()

        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
//        IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreateGroupVC.self]
        // arrayMsgs = MessageManager.shared.getMsgs(otherUserId)
    }
    
    
    @IBAction func actionBtnSubmitPressed(_ sender: Any)
    {
        
//        if imageSelected == nil
//        {
//            showAlert(title: "Drinks", message: "Please add image first.", controller: self)
//            return
//        }
        
//        if group.groupConditions[0].age == 0 ||  group.groupConditions[0].occupation.ID == ""
//        {
//            showAlert(title: "Drinks", message: "Please enter group type values.", controller: self)
//            return
//        }
        
//        if  group.groupConditions.count > 1
//        {
//            for i in 1 ..<  group.groupConditions.count
//            {
//                if  group.groupConditions[i].age == 0 ||  group.groupConditions[i].occupation.ID == ""
//                {
//                    showAlert(title: "Drinks", message: "Please enter group type values.", controller: self)
//                    return
//                }
//            }
//        }
        
//        if viewFooter.txtRelationship.text == ""
//        {
//            showAlert(title: "Drinks", message: "Please enter relationship for group.", controller: self)
//            return
//        }
        
//        if viewFooter.txtViewDescription.text == ""
//        {
//            showAlert(title: "Drinks", message: "Please enter description for group.", controller: self)
//            return
//        }
        group.groupDescription = (viewFooter.txtViewDescription.text.removeEndingSpaces()).replacingOccurrences(of: NSLocalizedString("We are drinking by three people, let's drink together! We are waiting for an offer!", comment: ""), with: "")
        if viewFooter.txtRelationship.text!.removeEndingSpaces() != "" {
            group.relationship = viewFooter.txtRelationship.text!.removeEndingSpaces()
        }else {
            group.relationship = NSLocalizedString("None", comment: "")

        }
        group.tagEnabled = self.tagEnabled
        
        var imageArray = [MSImage]()
        if imageSelected != nil
        {
            
            let fileName = "Drinks\(self.timeStamp).jpeg"
            // print(fileName)
            let resizedImage = resizeImage(image: imageSelected!, size: CGSize(width: 400 , height: 400 ))
            let model =  MSImage.init(file: resizedImage! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
            
        }else {
            
            let fileName = "Drinks\(self.timeStamp).jpeg"
            // print(fileName)
            let resizedImage = resizeImage(image: UserDp.image!, size: CGSize(width: 400 , height: 400 ))
            let model =  MSImage.init(file: resizedImage! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
        }


        if classAction == .Creating
        {
            
            if appDelegate().appLocation == nil
            {
                showAlert(title: "Drinks", message: NSLocalizedString("Please enable your location.", comment: ""), controller: self)
                return
                
            }
            group.location = appDelegate().appLocation
            
            group.createNewGroup(image: imageArray) { (isSuccess, response, strError) in
                if isSuccess{
                    if self.delegate != nil {
                        self.delegate?.replaceRecords!()
                    }
                    self.actionBtnBackPressed()
                }else{
                    
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            }
        }
        else{
            
            group.editGroup(image: imageArray, handler: { (isSuccess, response, strError) in
                if isSuccess
                {
                    if let groupUpdated = response as? Group
                    {
                        if self.delegate != nil {
                            self.delegate?.replaceRecords!(obj: groupUpdated)
                        }
                        self.actionBtnBackPressed()
                    }
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            })

            
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
            
            if classAction == .Creating{
                return group.groupConditions.count + 1

            }else{
                  return group.groupConditions.count + 1
            }
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
            
            if group.groupConditions.count == indexPath.row {
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
                
                if classAction == .Creating{
                    
                    if appDelegate().appLocation != nil
                    {
                        cell.lblLocationName.text = appDelegate().appLocation?.LocationName!
                    }
                }else{
                    
                    cell.lblLocationName.text = self.group.location?.LocationName
                }
                
             
                cell.callbackAction = {( action : GroupAction) in
                  if action == .LOCATION
                  {
                    SwiftLoader.show(true)
                    appDelegate().appLocation = GroupLocation()
                    appDelegate().intializeLocationManager()
                    self.refreshLocationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.refreshLocation), userInfo: nil, repeats: true)
                    
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
           
            if group.groupConditions.count == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier:"AddMoreCell") as! AddMoreCell
                cell.callbackAddMore = {(action : GroupAction ) in
                    
                    if self.group.groupConditions.count == 5{
                        showAlert(title: NSLocalizedString("The number of people has exceeded.", comment: ""), message: NSLocalizedString("Up to 6 people can be registered for this recruitment.", comment: ""), controller: self)
                        return
                    }
                    let firstCondition = GroupCondition()
                    self.group.groupConditions.append(firstCondition)
                    self.tblCreateGroup.reloadData()
                }
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"GroupInfoCell") as! GroupInfoCell
                cell.groupCond =  group.groupConditions[indexPath.row]

                
                cell.conditionCount = indexPath.row
                    cell.callbackAction = { (action : GroupAction , test : Any?) in
                        
                        if action == .DELETE
                        {
                        
                           self.view.endEditing(true)
                            let cellIndex = test as! Int
                            
                                if cellIndex < self.group.groupConditions.count
                                {
                                    self.group.groupConditions.remove(at: cellIndex)
                                    self.tblCreateGroup.reloadData()
                                }
                        }
                        
                    }
                cell.lblCounter.text = (indexPath.row + 2).description
                    cell.txtAge.delegate = self
                    cell.txtOccupation.delegate = self
                cell.btnCancel.isHidden = false

                   if  indexPath.row == 0 {
                     cell.btnCancel.isHidden = true
                     }
                
                    cell.setNewValues()
                    return cell
               
            }
        }
    }
    
    
    func refreshLocation() {
        if appDelegate().appLocation?.LocationName != "" {
            SwiftLoader.hide()
            self.tblCreateGroup.reloadData()
            refreshLocationTimer.invalidate()
        }
    }
    //MARK:- TextView Delegates
    //MARK:-
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.checkIsEmpty() == true{
            textView.textColor = UIColor.gray
            textView.text = NSLocalizedString("We are drinking by three people, let's drink together! We are waiting for an offer!", comment: "")
        }else{
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(textView.text!.characters.count)
        if text.characters.count == 0 {
            return true
        }else {
            if textView.text!.characters.count == 40 || textView.text!.characters.count + text.characters.count > 40 {
                showAlert(title: "Drinks", message: "Maximum characters limit reached.", controller: self)
                return false
            }else {
                return true
            }
        }
       
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black

        if textView.text == NSLocalizedString("We are drinking by three people, let's drink together! We are waiting for an offer!", comment: "")
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
            
            if textField.tag == 100{
                
                let ageArray = arrayAges.filter {
                    ($0 == selectedCondtion?.age)
                }
                if ageArray.count > 0 {
                    let index = arrayAges.index(of: ageArray[0])
                    pickerAgeSelection.selectRow(index!, inComponent: 0, animated: false)
                }else{
                    
                    pickerAgeSelection.selectRow(0, inComponent: 0, animated: false)
                    
                }
                textField.inputView = pickerAgeSelection

                
            }else{
                let jobArray = arrayJobs.filter {
                    ($0.ID ==  selectedCondtion?.occupation.ID)
                }
                if jobArray.count > 0 {
                    let index = arrayJobs.index(of: jobArray[0])
                    pickerOccpuation.selectRow(index!, inComponent: 0, animated: false)
                }else{
                    pickerOccpuation.selectRow(0, inComponent: 0, animated: false)
                    
                }
                textField.inputView = pickerOccpuation
                
            }

        }
        else{
            if textField.text != "" && textField.text != NSLocalizedString("None", comment: "") && textField.text != NSLocalizedString("Open", comment: "")
            {
                let index = arrayRelations.index(of: textField.text!)
                pickerRelationShip.selectRow(index!, inComponent: 0, animated: false)
            }
            
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == viewFooter.txtRelationship{
        let seletedRelation = pickerRelationShip.selectedRow(inComponent: 0)
        viewFooter.txtRelationship.text = arrayRelations[seletedRelation]
      
        }else{
            
            
            let index = tblCreateGroup.indexPath(for: cellSelected!)

            
            if textField.tag == 100{
                let firstRow = pickerAgeSelection.selectedRow(inComponent: 0)
                group.groupConditions[(index?.row)!].age = arrayAges[firstRow]

            }else{
                let secondRow = pickerOccpuation.selectedRow(inComponent: 0)
                group.groupConditions[(index?.row)!].occupation = arrayJobs[secondRow]
            }

            //self.tblCreateGroup.reloadData()
        }
    }
    
    //MARK:- UIPicker View Delegates
    //MARK:-
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerRelationShip {
              return arrayRelations.count
        }else if pickerView == pickerAgeSelection {
            return arrayAges.count
        }else {
            return arrayJobs.count
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // all picker has one component
      
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerRelationShip {
            return arrayRelations[row]
        }else if pickerView == pickerAgeSelection {
            return arrayAges[row].description
        }else {
            if Locale.preferredLanguages[0].contains("en") {
                return arrayJobs[row].engName
            }else {
                return arrayJobs[row].japName
            }
        }
   }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerRelationShip{
            viewFooter.txtRelationship.text = arrayRelations[row]
        }else if pickerView == pickerAgeSelection {
            cellSelected?.txtAge.text = arrayAges[row].description
            cellSelected?.groupCond.age = arrayAges[row]
        }else {
            if Locale.preferredLanguages[0].contains("en") {
                cellSelected?.txtOccupation.text = arrayJobs[row].engName
            }else {
                cellSelected?.txtOccupation.text = arrayJobs[row].japName
            }
            cellSelected?.groupCond.occupation = arrayJobs[row]

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
