//
//  VerifiedImageVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/26/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class VerifiedImageVC: UIViewController, MSGetImage {

    @IBOutlet weak var lblDocumentStatus: UILabel!
    @IBOutlet weak var imgVW: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgVW.sd_setImage(with: URL(string: LoginManager.getMe.ageDocument))
        if (LoginManager.getMe.ageVerified.toBool())! {
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
        openCustomCamera()
    }
    
    //MARK:- Select Photo
    //MARK:-
    func openCustomCamera(){
        
        let camera =  msCameraStoryBoard.instantiateViewController(withIdentifier: "MSCameraGallery") as! MSCameraGallery
        camera.cameFor = "rear"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
