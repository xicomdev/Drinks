//
//  ReportGroupVC.swift
//  Drinks
//
//  Created by maninder on 9/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ReportGroupVC: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    var group : Group!
    
    var delegate : MSProtocolCallback? = nil
    let placeHolder = "Please mention your reason."
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtViewReason: UITextView!
    var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ReportGroupVC.actionBtnBackPressed))
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navTitle(title: "Report" as NSString  , color: UIColor.black , font:  FontRegular(size: 19))

        
        
        datePicker.datePickerMode = UIDatePickerMode.date
        //datePicker.format = "YYYY/MM/dd"
        // previousDate
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        btnSend.cornerRadius(value: 22.5)
        txtViewReason.delegate = self
        txtViewReason.textColor = APP_PlaceHolderColor
        txtViewReason.text = placeHolder
        txtDate.delegate = self
        txtDate.inputView = datePicker
        
       // txtDate.text = dateFormatter.string(from: Date())

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func actionBtnBackPressed()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func dateChanged(_ sender: UIDatePicker) {
        
        let today = Date()
        
        if sender.date.compare(today) == .orderedAscending ||  sender.date.compare(today) == .orderedSame
        {
            txtDate.text = dateFormatter.string(from: sender.date)
        }
        
        
    }
    

    
    //MARK:- TextField Delegates
    //MARK:-

    func textFieldDidEndEditing(_ textField: UITextField) {
        txtDate.text = dateFormatter.string(from: datePicker.date)

    }
    
    
    //MARK:- TextView Delegates
    //MARK:-
    
    
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let characterLimit = 140
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < characterLimit
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if txtViewReason.text == placeHolder{
             txtViewReason.text  = ""
            txtViewReason.textColor = .black

        }else{
            txtViewReason.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        if (textView.text).checkIsEmpty() == true
        {
            txtViewReason.text = placeHolder
            txtViewReason.textColor = APP_PlaceHolderColor
        }else{
            txtViewReason.textColor = .black
        }
    }
    @IBAction func actionBtnSend(_ sender: UIButton) {
        
        if txtViewReason.text == placeHolder || (txtViewReason.text).checkIsEmpty()
        {
            showAlert(title: "Drinks" , message: "Please mention your reason first.", controller: self)
        }else{
            
            self.view.endEditing(true)
            group.reportGroup(reason: txtViewReason.text.removeEndingSpaces()   , date: txtDate.text! , handler: { (isSuccess, response, strError) in
                if isSuccess
                {
                    
                    if self.delegate != nil{
                        self.delegate?.actionMoveToPreviousVC!()
                        self.navigationController?.popViewController(animated: true)
                    }
                    

                    
                }else{
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            })
        }
    }
    
    //MARK:- MSProtocolCallback Delegates
    //MARK:-
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
