//
//  DrinkTodayChatVC.swift
//  Drinks
//
//  Created by Ankit Chhabra on 8/31/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class DrinkTodayChatVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMsgVwHgt: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtVWMsg: IQTextView!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblNoOfPersons: UILabel!
    @IBOutlet weak var lblGroupTag: UILabel!
    @IBOutlet weak var imgVwGroup: UIImageView!
    
    var arrayMsgs = [Message]()
    var otherUserId = "2"

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
        self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = false
        arrayMsgs = MessageManager.shared.getMsgs(otherUserId)
        tblChat.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewDidDisappear(animated)
        self.stopKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = true
        
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
        let msgDict = [
            "msgId":"1",
            "msgContent": txtVWMsg.text!,
            "timestamp": "\(Date().timeIntervalSince1970)",
            "senderId": "1",
            "recieverId": "\(otherUserId)"
        ]
        
        MessageManager.shared.saveMsgs([msgDict])
        arrayMsgs = MessageManager.shared.getMsgs(otherUserId)
        txtVWMsg.text = ""
        bottomMsgVwHgt.constant = 50
        tblChat.reloadData()
        self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)
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

    func scrollToBottomInitial() {
        let oldCount: Int = arrayMsgs.count
        if oldCount != 0  {
            let lastRowNumber: Int = tblChat.numberOfRows(inSection: 0) - 1
            if lastRowNumber > 0 {
                let ip: IndexPath = IndexPath(row: lastRowNumber, section: 0)
                tblChat.scrollToRow(at: ip, at: .bottom, animated: true)
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newHeight = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).height
        print(newHeight)
        if newHeight > 34 && newHeight < 85{
            bottomMsgVwHgt.constant = newHeight + 16
        }else if newHeight > 85{
            bottomMsgVwHgt.constant = 85
        }else {
            bottomMsgVwHgt.constant = 50
        }
    }
    
    //MARK: - TableView Delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgObj: Message = arrayMsgs[indexPath.row]
        let returnCell : UITableViewCell!
        if msgObj.senderId == "1" {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SentMsgCell", for: indexPath) as! SentMsgCell
            cell.lblMsg.text = msgObj.msgContent
            cell.lblTime.text = msgObj.timestamp.getTimeFromTimestamp()
            returnCell = cell
        }else {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "RecievedMsgCell", for: indexPath) as! RecievedMsgCell
            cell.lblTime.text = msgObj.timestamp.getTimeFromTimestamp()
            cell.lblMsg.text = msgObj.msgContent
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
