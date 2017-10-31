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
            
            let model =  MSImage.init(file: resizedImage! , variableName: "image", fileName: fileName, andMimeType: "image/jpeg")
            imageArray.append(model)
        }
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: "", paramters: nil, Images: imageArray, handler: { (isSuccess, response, strError) in
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
