//
//  AgeVerificationDetailsVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 9/2/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class AgeVerificationDetailsVC: UIViewController , MSGetImage{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnCrossAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartVerificationAction(_ sender: AnyObject) {
        openCustomCamera()
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
            let previewVc = mainStoryBoard.instantiateViewController(withIdentifier: "PreviewVerificationVC") as! PreviewVerificationVC
            previewVc.selectedImg = (selected as? UIImage)!
            self.navigationController?.pushViewController(previewVc, animated: false)
            
        }
    }
}
