//
//  NoRecruitVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class NoRecruitVC: UIViewController {

    var delegate : MSSelectionCallback? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionBtnRecruit(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.moveHomeToAddNew!(false)
        })
    }
    @IBAction func actionBtnCloseup(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.moveHomeToAddNew!(true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
