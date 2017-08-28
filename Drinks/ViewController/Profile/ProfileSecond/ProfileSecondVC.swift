//
//  ProfileSecondVC.swift
//  Drinks
//
//  Created by maninder on 8/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ProfileSecondVC: UIViewController,MSSelectionCallback {
    @IBOutlet var txtMarriage: UITextField!
    
    
    var imageSelected : UIImage? = nil
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnIncome: UIButton!
    @IBOutlet var btnSchool: UIButton!
    
   var activeSelection : SelectionType = .Blood
    @IBOutlet var txtSchool: UITextField!
    
    @IBOutlet var txtIncome: UITextField!

    @IBOutlet var txtTabacco: UITextField!
    @IBOutlet var btnTabacco: UIButton!
    @IBOutlet var btnMarriage: UIButton!
    @IBOutlet var btnBloodType: UIButton!
    @IBOutlet var txtBloodType: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.btnSubmit.cornerRadius(value: 22.5)
        

        self.txtBloodType.text = LoginManager.getMe.bloodGroup
        self.txtMarriage.text = LoginManager.getMe.relationship
        self.txtTabacco.text = LoginManager.getMe.tabaco
        self.txtIncome.text = LoginManager.getMe.annualIncome
        self.txtSchool.text = LoginManager.getMe.schoolCareer
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Action functions
    //MARK:-
    
    @IBAction func actionBtnSelectionPressed(_ sender: UIButton) {
        
        
        let selectVc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        selectVc.delegate = self
        
        if sender == btnBloodType
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

    @IBAction func actionBtnPreviousPhase(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionBtnSubmitPressed(_ sender: Any) {
        
        if LoginManager.getMe.bloodGroup == ""
        {
            
            showAlert(title: "Drinks", message: "Please select blood group first.", controller: self)
            return
        }else if LoginManager.getMe.relationship == ""
        {
            showAlert(title: "Drinks", message: "Please select your relationship status.", controller: self)
             return

        }else if LoginManager.getMe.tabaco == ""{
            showAlert(title: "Drinks", message: "Please select tabacco option first.", controller: self)
             return

        }else if LoginManager.getMe.schoolCareer == ""{
            showAlert(title: "Drinks", message: "Please select school career first.", controller: self)
             return
 
            
        }else if LoginManager.getMe.annualIncome == "" {
            showAlert(title: "Drinks", message: "Please select annual income first.", controller: self)
            return
            
        }
        
        var imageArray = [MSImage]()
        
        print(imageSelected)
        if imageSelected != nil{
          
            let fileName = "Drinks\(self.timeStamp).jpeg"
            
            let resizedImage = resizeImage(image: imageSelected!, size: CGSize(width: 300 , height: 300 ))

            let model =  MSImage.init(file: resizedImage! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
        }
        
        LoginManager.sharedInstance.signUp(image: imageArray) { (isSuccess, response, strError) in
            if isSuccess
            {
                let myDetails = LoginManager.sharedInstance.getMeArchiver()
                let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                appDelegate().window?.rootViewController = tabBarController
            
            }else{
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
    
    
    //MARK:- Custom Delegates
    //MARK:-
    
    func moveWithSelection(selected: Any) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
