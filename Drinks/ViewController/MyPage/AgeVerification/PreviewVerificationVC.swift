//
//  PreviewVerificationVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/26/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PreviewVerificationVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    var selectedImg = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        imgVw.image = selectedImg
    }
    
    @IBAction func actionCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUploadBtn(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
