//
//  GenericPageVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 10/17/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GenericPageVC: UIViewController, UIWebViewDelegate {

    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet weak var webVw: UIWebView!
    
    var apiURL = ""
    var strTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        webVw.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        lblScreenTitle.text = NSLocalizedString(strTitle, comment: "")
        webVw.loadRequest(URLRequest(url: URL(string: apiURL)!))
        // Do any additional setup after loading the view.
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        SwiftLoader.show(true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SwiftLoader.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SwiftLoader.hide()
        showAlert(title: "Drinks", message: error.localizedDescription, controller: self)
    }
    @IBAction func actionCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
