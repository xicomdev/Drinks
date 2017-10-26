//
//  VerifiedImageVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/26/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class VerifiedImageVC: UIViewController {

    @IBOutlet weak var lblDocumentStatus: UILabel!
    @IBOutlet weak var imgVW: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgVW.sd_setImage(with: URL(string: LoginManager.getMe.ageDocument))
        if Bool(NSNumber(value: Int(LoginManager.getMe.ageVerified)!)) {
            lblDocumentStatus.text = "Document Verified"
            lblDocumentStatus.textColor = UIColor.green
        }else {
            lblDocumentStatus.text = "Verification Pending"
            lblDocumentStatus.textColor = UIColor.red
        }
    }

    @IBAction func actionCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionUpdateBtn(_ sender: Any) {
        
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
