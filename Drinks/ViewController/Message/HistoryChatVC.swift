//
//  HistoryChatVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/31/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class HistoryChatVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMsgVwHgt: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtVWMsg: IQTextView!
    @IBOutlet weak var tblChat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        tblChat.tableFooterView = UIView()
        txtVWMsg.delegate = self
        tblChat.registerNibsForCells(arryNib: ["SentMsgCell","RecievedMsgCell"])
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionBtnBackPressed))
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        self.navTitle(title: "Ankit (25 yrs)", color: UIColor.black , font:  FontRegular(size: 19))
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.reloadData()
        
    }
    
    func actionBtnBackPressed() {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func btnSendAction(_ sender: AnyObject) {
        if txtVWMsg.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: "Drinks", message: "Please enter message", controller: self)
        }else {
            sendMsg()
        }
    }
    
    func sendMsg() {
        arrayMsgs.append((txtVWMsg.text!,1))
        txtVWMsg.text = ""
        bottomMsgVwHgt.constant = 50
        tblChat.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewDidDisappear(animated)
        self.stopKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    //MARK :- Handle Keyboard
    fileprivate func startKeyboardObserver()  {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func stopKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification)  {
        if let userInfo = notification.userInfo  {
            if let keyboardSize: CGSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue.size
            {
                bottomMargin.constant = keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomMargin.constant = 0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newHeight = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).height
        if newHeight > 34 {
            bottomMsgVwHgt.constant = newHeight + 16
        }else {
            bottomMsgVwHgt.constant = 50
        }
    }
    
    //MARK: - TableView Delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgTuple:(String,Int) = arrayMsgs[indexPath.row]
        let returnCell : UITableViewCell!
        if msgTuple.1 == 1 {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SentMsgCell", for: indexPath) as! SentMsgCell
            cell.lblMsg.text = msgTuple.0
            returnCell = cell
        }else {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "RecievedMsgCell", for: indexPath) as! RecievedMsgCell
            cell.lblMsg.text = msgTuple.0
            returnCell = cell
        }
        returnCell.layoutSubviews()
        returnCell.layoutIfNeeded()
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tblChat.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
    }


}
