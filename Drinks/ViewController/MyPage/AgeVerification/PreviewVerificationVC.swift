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
    var selectedImg : UIImage? = nil
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
        var imageArray = [MSImage]()
        if selectedImg != nil{
            
            let fileName = "Drinks\(self.timeStamp).jpeg"
            
            let resizedImage = resizeImage(image: selectedImg!, size: CGSize(width: 300 , height: 300 ))
            
            let model =  MSImage.init(file: resizedImage! , variableName: "age_document", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
        }
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API_ageVerify, paramters: nil, Images: imageArray, handler: { (isSuccess, response, strError) in
            SwiftLoader.hide()
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                showAlert(title: "Drinks", message: strError!, controller: self)
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
