class DrinkTodayChatVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var thread = ChatThread()
    
   // var arrayMessages = [MessageEntity]()
    var timerChat : Timer!

    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMsgVwHgt: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtVWMsg: IQTextView!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblNoOfPersons: UILabel!
    @IBOutlet weak var lblGroupTag: UILabel!
    @IBOutlet weak var imgVwGroup: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        tblChat.tableFooterView = UIView()
        
        txtVWMsg.delegate = self
        tblChat.registerNibsForCells(arryNib: ["SentMsgCell","RecievedMsgCell"])
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionBtnBackPressed))
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        let secondUserInfo =  (thread.threadMember.fullName!) + " " + (thread.threadMember.age.description)
        
        self.navTitle(title: secondUserInfo  as NSString , color: UIColor.black , font:  FontRegular(size: 17))
        
        tblChat.delegate = self
        tblChat.dataSource = self
        self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)
        lblGroupTag.cornerRadius(value : 10)
        self.getAllThreadMessages()
        
        imgVwGroup.sd_setImage(with: URL(string :  thread.group.imageURL))
        
        setNoOfMembers(groups: thread.group.groupConditions , label: lblNoOfPersons, relation: thread.group.relationship)
        
        lblLocation.text = thread.group.location?.LocationName

       lblGroupTag.isHidden =  !thread.group.tagEnabled
        
        
        timerChat =  Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (result) in
            self.getAllThreadMessages()
            
        })

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        self.getAllThreadMessages()
     //   arrayMsgs = MessageManager.shared.getMsgs(otherUserId)
        tblChat.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewDidDisappear(animated)
        self.stopKeyboardObserver()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        timerChat.invalidate()
        
    }
    
    
    func actionBtnBackPressed() {
        appDelegate().currentThread = nil
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnSendAction(_ sender: AnyObject) {
        if txtVWMsg.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           // showAlert(title: "Drinks", message: "Please enter message", controller: self)
        }else {
            sendMsg()
        }
    }
    
    func sendMsg() {
        
        self.sendMessageAPI(textMessage: txtVWMsg.text.removeEndingSpaces())
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

                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomMargin.constant = keyboardSize.height

                })
                self.view.layoutIfNeeded()

            }
            self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)

        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomMargin.constant = 0

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })

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
    
    //MARK: - TableView Delegate and datasource methods=
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return thread.messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let msgObj: Message = arrayMsgs[indexPath.row]
        
        var returnCell : UITableViewCell!
        
        let message = thread.messages[indexPath.row]
        if LoginManager.getMe.ID == message.senderID
        {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SentMsgCell", for: indexPath) as! SentMsgCell
            cell.setMessageDetails(msgInfo: message)
           returnCell = cell
            
        }else{
            
            let cell = tblChat.dequeueReusableCell(withIdentifier: "RecievedMsgCell", for: indexPath) as! RecievedMsgCell
            cell.setMessageDetails(msgInfo: message)
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
    
    //MARK:- Get All Thread Messages
    //MARK:-
    
    func getAllThreadMessages(){
        
        thread.getAllMessages { (isSuccess, response, error) in
            if isSuccess{
                if let thread = response  as? ChatThread
                {
                    self.thread = thread
                    self.tblChat.reloadData()
                    self.moveToLastCell()
                }
            }
        }
    }
    
    func sendMessageAPI(textMessage : String)
    {
        thread.sendMessage(message: textMessage) { (isSuccess, response, error) in
            if isSuccess
            {
                if let newMessage = response as? Message
                {
                  self.thread.messages.append(newMessage)
                   self.tblChat.reloadData()
                    self.moveToLastCell()
                }
            }else{
                showAlert(title: "Drinks", message: error!, controller: self)
            }
        }
    }
    
    func moveToLastCell(){
        self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)
    }
}
