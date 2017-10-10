//
//  UpdateProfileVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Photos

class UpdateProfileVC: UIViewController, MSSelectionCallback,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet var lblOccupation: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var imgViewUser: UIImageView!
    @IBOutlet var txtMarriage: UITextField!
    @IBOutlet weak var btnOccupation: UIButton!
    @IBOutlet var btnIncome: UIButton!
    @IBOutlet var btnSchool: UIButton!
    @IBOutlet var txtSchool: UITextField!
    @IBOutlet var txtIncome: UITextField!
    @IBOutlet var txtTabacco: UITextField!
    @IBOutlet var btnTabacco: UIButton!
    @IBOutlet var btnMarriage: UIButton!
    @IBOutlet var btnBloodType: UIButton!
    @IBOutlet var txtBloodType: UITextField!

    var imageSelected : UIImage? = nil
    var datePicker = UIDatePicker()
    var activeSelection : SelectionType = .Blood

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        imgViewUser.cornerRadius(value: imgViewUser.frame.size.width/2)
        imgViewUser.sd_setImage(with: URL(string: LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        // previousDate
        
        let minimumDate = (Date() as NSDate).addingYears(-18)
        datePicker.setDate(minimumDate!, animated: false)
        
        txtDOB.text = dateFormatter.string(from: minimumDate!)
        lblAge.text = "\(txtDOB.text!.getAgeFromDOB())"
        LoginManager.getMe.age = txtDOB.text!.getAgeFromDOB()
        LoginManager.getMe.DOB = txtDOB.text!
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        txtDOB.inputView = datePicker
        
        lblOccupation.textColor = UIColor.black
        lblOccupation.text = LoginManager.getMe.job.engName
        txtUserName.text = LoginManager.getMe.fullName
        
        self.txtBloodType.text = LoginManager.getMe.bloodGroup
        self.txtMarriage.text = LoginManager.getMe.relationship
        self.txtTabacco.text = LoginManager.getMe.tabaco
        self.txtIncome.text = LoginManager.getMe.annualIncome
        self.txtSchool.text = LoginManager.getMe.schoolCareer
        
        self.txtDOB.isUserInteractionEnabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        
        
        let today = NSDate()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let age = gregorian.components([.year], from: sender.date, to: today as Date, options: [])
        if age.year! >= 18 {
            txtDOB.text = dateFormatter.string(from: sender.date)
            lblAge.text = "\(txtDOB.text!.getAgeFromDOB())"
            
            LoginManager.getMe.age = txtDOB.text!.getAgeFromDOB()
            LoginManager.getMe.DOB = dateFormatter.string(from: sender.date)
        }else{
            sender.date = today.addingYears(-18)
        }
    }
    
    @IBAction func actionCameraPressed(_ sender: UIButton) {
        self.openImageSelection()
    }
 
    @IBAction func btnSaveAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if txtUserName.text!.isStringEmpty() == true{
            showAlert(title: "Drinks", message: "Please enter user name.", controller: self)
        }
        else if LoginManager.getMe.job.ID == ""{
            showAlert(title: "Drinks", message: "Please select your occupation.", controller: self)
        }
        else if txtDOB.text! == ""{
            showAlert(title: "Drinks", message: "Please enter your DOB.", controller: self)
        }
        else  if LoginManager.getMe.bloodGroup == ""{
            showAlert(title: "Drinks", message: "Please select blood group first.", controller: self)
        }
        else if LoginManager.getMe.relationship == ""{
            showAlert(title: "Drinks", message: "Please select your relationship status.", controller: self)
        }
        else if LoginManager.getMe.tabaco == ""{
            showAlert(title: "Drinks", message: "Please select tabacco option first.", controller: self)
        }
        else if LoginManager.getMe.schoolCareer == ""{
            showAlert(title: "Drinks", message: "Please select school career first.", controller: self)
        }
        else if LoginManager.getMe.annualIncome == "" {
            showAlert(title: "Drinks", message: "Please select annual income first.", controller: self)
        }
        else {
            var imageArray = [MSImage]()
            
            print(imageSelected)
            if imageSelected != nil{
                
                let fileName = "Drinks\(self.timeStamp).jpeg"
                
                let resizedImage = resizeImage(image: imageSelected!, size: CGSize(width: 300 , height: 300 ))
                
                let model =  MSImage.init(file: resizedImage! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
                imageArray.append(model)
            }
            
//            LoginManager.sharedInstance.signUp(image: imageArray) { (isSuccess, response, strError) in
//                if isSuccess
//                {
//                    let myDetails = LoginManager.sharedInstance.getMeArchiver()
//                    let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
//                    appDelegate().window?.rootViewController = tabBarController
//                    
//                }else{
//                    showAlert(title: "Drinks", message: strError!, controller: self)
//                }
//            }
        }
        
    }
    
    
    //MARK:- Select Photo
    //MARK:-
    
    func openImageSelection()
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        let GalleryAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            
            self.openGalleryWithPermissions()
            //Just dismiss the action sheet
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.openCameraWithPermissions()
            //Just dismiss the action sheet
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionSheetController.addAction(GalleryAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCameraWithPermissions()
    {
        let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.authorized
        {
            self.openCamera()
        }else if  status == AVAuthorizationStatus.denied
        {
            //  showAlert(AppName, message: "Camera permissions are disabled.", controller: self)
        }else if  status == AVAuthorizationStatus.restricted
        {
            // showAlert(AppName, message: "Camera permissions are disabled.", controller: self)
        }else if  status == AVAuthorizationStatus.notDetermined{
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (Bool) in
                if Bool {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }else{
                }
            })
        }
    }
    
    
    func openCamera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: {
        })
    }
    
    func openGalleryWithPermissions()
    {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        self.present(imagePicker, animated: true, completion: {
                        })
                    }
                }
                break
            case .denied:
                print("Denied")
                break
            default:
                print("Default")
                break
            }
        }
    }
    
    //MARK:- ImagePicker Delegate
    //MARK:-
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            //  564x290
            
            //            let width = KiteManager.getKite.product?.selectedTemplate.templatePhotoWidth
            //            let height = KiteManager.getKite.product?.selectedTemplate.templatePhotoHeight
            //
            //            let imageCropped = resizeImage(image: pickedImage, size: CGSize(width: width! , height: height! ))
            //            imgViewDefault.isHidden = true
            
            imgViewUser.image = pickedImage
            imageSelected = pickedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func actionBtnSelectionPressed(_ sender: UIButton) {
        
        
        let selectVc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        selectVc.delegate = self
        
        if sender == btnOccupation
        {
            activeSelection = .Occupation
            selectVc.selectType = .Occupation
            selectVc.selectedJob = LoginManager.getMe.job
            
        }else if sender == btnBloodType
        {
            selectVc.selectType = .Blood
            activeSelection = .Blood
            selectVc.selectedValue = LoginManager.getMe.bloodGroup
            
        }else  if sender == btnMarriage
        {
            selectVc.selectType = .Marriage
            activeSelection = .Marriage
            selectVc.selectedValue = LoginManager.getMe.relationship
            
            
        }else  if sender == btnTabacco
        {
            selectVc.selectType = .Tabacco
            activeSelection = .Tabacco
            selectVc.selectedValue = LoginManager.getMe.tabaco
            
        }else  if sender == btnSchool
        {
            selectVc.selectType = .School
            activeSelection = .School
            selectVc.selectedValue = LoginManager.getMe.schoolCareer
            
        }else  if sender == btnIncome
        {
            selectVc.selectType = .Income
            activeSelection = .Income
            selectVc.selectedValue = LoginManager.getMe.annualIncome
            
        }
        self.navigationController?.pushViewController(selectVc, animated: true)
        
    }
    
    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Custom Delegates
    //MARK:-
    
    func moveWithSelection(selected: Any) {
        
        if activeSelection == .Occupation {
            LoginManager.getMe.job = selected as! Job
            lblOccupation.text =  LoginManager.getMe.job.engName
            lblOccupation.textColor = UIColor.black
        }else {
            let strSelected = selected as! String
            if activeSelection == .Blood
            {
                LoginManager.getMe.bloodGroup = strSelected
                txtBloodType.text = strSelected
                
            }else  if activeSelection == .Marriage
            {
                LoginManager.getMe.relationship = strSelected
                txtMarriage.text = strSelected
                
            }else  if activeSelection == .Tabacco
            {
                LoginManager.getMe.tabaco = strSelected
                txtTabacco.text = strSelected
                
            }else  if activeSelection == .School
            {
                LoginManager.getMe.schoolCareer = strSelected
                txtSchool.text = strSelected
                
            }else  if activeSelection == .Income
            {
                LoginManager.getMe.annualIncome = strSelected
                txtIncome.text = strSelected
            }
        }
        
    }

}
