//
//  ProfileFirstVC.swift
//  Drinks
//
//  Created by maninder on 8/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Photos



class ProfileFirstVC: UIViewController,MSSelectionCallback,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet var lblOccupation: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    var imageSelected : UIImage? = nil
    var datePicker = UIDatePicker()
    
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var imgViewUser: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        imgViewUser.cornerRadius(value: imgViewUser.frame.size.width/2)
        imgViewUser.sd_setImage(with: URL(string: LoginManager.getMe.imageURL), placeholderImage: userPlaceHolder)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        // previousDate
        
        let minimumDate = (Date() as? NSDate)?.addingYears(-18)
        datePicker.setDate(minimumDate!, animated: false)
        
        txtDOB.text = dateFormatter.string(from: minimumDate!)
        lblAge.text = "\(txtDOB.text!.getAgeFromDOB())"
        LoginManager.getMe.age = txtDOB.text!.getAgeFromDOB()
        LoginManager.getMe.DOB = txtDOB.text!
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        txtDOB.inputView = datePicker
        
        lblOccupation.textColor = UIColor.lightGray
        lblOccupation.text = "Select Occupation"
        txtUserName.text = LoginManager.getMe.fullName
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
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
    
    @IBAction func btnSkipAction(_ sender: AnyObject) {
    }
    
    @IBAction func actionBtnNextPhase(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if txtUserName.text!.isStringEmpty() == true{
            showAlert(title: "Drinks", message: "Please enter user name.", controller: self)
            return
        }
        
        if LoginManager.getMe.job.ID == ""
        {
            showAlert(title: "Drinks", message: "Please select your occupation.", controller: self)
            return
        }
        
        if txtDOB.text! == ""
        {
            showAlert(title: "Drinks", message: "Please enter your DOB.", controller: self)
            return
        }
        
        let profileSecondVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileSecondVC") as! ProfileSecondVC
        profileSecondVC.imageSelected = imageSelected
        self.navigationController?.pushViewController(profileSecondVC, animated: true)
        
        
    }
    
    @IBAction func actionBtnOccupation(_ sender: Any) {
        
        let selectVc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        selectVc.selectType = .Occupation
        selectVc.selectedJob = LoginManager.getMe.job
        selectVc.delegate = self
        self.navigationController?.pushViewController(selectVc, animated: true)
    }
    
    @IBAction func actionFillProfilePressed(_ sender: Any) {
        self.view.endEditing(true)
        //        if txtUserName.text!.isStringEmpty() == true{
        //
        //            showAlert(title: "Drinks", message: "Please enter user name.", controller: self)
        //            return
        //        }
        //
        //        if LoginManager.getMe.job.ID == ""
        //        {
        //            showAlert(title: "Drinks", message: "Please select your occupation.", controller: self)
        //            return
        //        }
        //
        //        if txtDOB.text! == ""
        //        {
        //            showAlert(title: "Drinks", message: "Please enter your DOB.", controller: self)
        //            return
        //        }
        //
        //        let profileSecondVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileSecondVC") as! ProfileSecondVC
        //        profileSecondVC.imageSelected = imageSelected
        //        self.navigationController?.pushViewController(profileSecondVC, animated: true)
        
    }
    //MARK:- Custom Delegates
    //MARK:-
    
    
    func moveWithSelection(selected: Any) {
        LoginManager.getMe.job = selected as! Job
        lblOccupation.text =  LoginManager.getMe.job.engName
        lblOccupation.textColor = UIColor.black
        
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
            imgViewUser.image = pickedImage
            imageSelected = pickedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- Custom Delegates
    
    
}
