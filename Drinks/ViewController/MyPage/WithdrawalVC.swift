//
//  WithdrawalVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 11/29/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class WithdrawalVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var picker = UIPickerView()
    @IBOutlet weak var txtfldSelectreason: UITextField!
    let aryReasons = ["A lover was found in DRINKS.","I got tired."]
    override func viewDidLoad() {
        super.viewDidLoad()

        txtfldSelectreason.text = NSLocalizedString("Select reason for leaving", comment: "")
        txtfldSelectreason.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        txtfldSelectreason.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtfldSelectreason.text == NSLocalizedString("Select reason for leaving", comment: "") {
            txtfldSelectreason.text = NSLocalizedString("A lover was found in DRINKS.", comment: "")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryReasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(aryReasons[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtfldSelectreason.text = NSLocalizedString(aryReasons[row], comment: "")
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLeaveBtn(_ sender: Any) {
        if txtfldSelectreason.text !=  NSLocalizedString("Select reason for leaving", comment: ""){
            let parms = ["deleted_reason":txtfldSelectreason.text!]
            
            print(parms)
            SwiftLoader.show(true)
            
            HTTPRequest.sharedInstance().postRequest(urlLink: API_LeaveUser, paramters: parms, handler: { (status, response, strError) in
                SwiftLoader.hide()
                if status {
                    getOutOfApp()
                }else {
                    showAlert(title: "Drinks", message: strError!, controller: self)
                }
            })
        }else {
            showAlert(title: "Drinks", message: NSLocalizedString("Please select reason for leaving.", comment: ""), controller: self)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
