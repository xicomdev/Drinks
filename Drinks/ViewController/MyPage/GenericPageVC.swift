//
//  GenericPageVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GenericPageVC: UIViewController {

    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet weak var txtVw: UITextView!
    
    var strTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        lblScreenTitle.text = NSLocalizedString(strTitle, comment: "")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
