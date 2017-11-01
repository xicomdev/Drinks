//
//  MessageVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MessageVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var imgViewNoThread: UIImageView!
    
    @IBOutlet var lblNoThread: UILabel!
    
    @IBOutlet var viewOuter: UIView!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnDrinkToday: UIButton!
    @IBOutlet weak var tableviewGroupMessages: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        viewOuter.cornerRadius(value: 17.5)
        btnDrinkToday.cornerRadius(value: 17.5)

        btnHistory.cornerRadius(value: 17.5)

        
        
        btnDrinkToday.isSelected = true
        btnDrinkToday.backgroundColor = APP_BlueColor
        
        tableviewGroupMessages.registerNibsForCells(arryNib: ["DrinkTodayCell","HistoryMsgCell","DrinkTodayNoMessageCell"])
        tableviewGroupMessages.delegate = self
        tableviewGroupMessages.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableviewGroupMessages.reloadData()
        self.navigationController?.isNavigationBarHidden = true
        self.updateUI()
        self.getThreadsForGroups()
        self.getThreadsForHistory()

    }
    
    @IBAction func btnDrinkTodayAction(_ sender: AnyObject) {
        self.getThreadsForGroups()

        btnDrinkToday.isSelected = true
        btnHistory.isSelected = false
        btnDrinkToday.backgroundColor = APP_BlueColor
        btnHistory.backgroundColor = APP_GrayColor
        tableviewGroupMessages.reloadData()
    }

    @IBAction func btnHistoryAction(_ sender: AnyObject) {
        self.getThreadsForHistory()

        btnHistory.isSelected = true
        btnDrinkToday.isSelected = false
        btnDrinkToday.backgroundColor = APP_GrayColor
        btnHistory.backgroundColor = APP_BlueColor
        tableviewGroupMessages.reloadData()
    }
    
    //MARK:- TableView Delegates
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btnDrinkToday.isSelected {
            return appDelegate().arrayThread.count
            
        }else {
            return appDelegate().arrayHistoryThreads.count
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if btnDrinkToday.isSelected {
            
            if appDelegate().arrayThread[indexPath.row].lastMessage != nil
            {
                return 175
            }else{
                return 84
            }
            
        }else {
            return 96
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnDrinkToday.isSelected {
            
            if appDelegate().arrayThread[indexPath.row].lastMessage != nil
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTodayCell", for: indexPath) as! DrinkTodayCell
                  cell.assignCellData(thread: appDelegate().arrayThread[indexPath.row])
                return cell

            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTodayNoMessageCell", for: indexPath) as! DrinkTodayNoMessageCell
                  cell.assignCellData(thread: appDelegate().arrayThread[indexPath.row])
                return cell
            }
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryMsgCell", for: indexPath) as! HistoryMsgCell
            cell.assignCellData(thread: appDelegate().arrayHistoryThreads[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if LoginManager.getMe.membershipStatus == "Regular" {
            showAlert(title: "Drinks", message: "You must buy premium membership to send messages.", controller: self)
        }else {
            if (LoginManager.getMe.ageVerified.toBool())! {
                if btnDrinkToday.isSelected {
                    let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "DrinkTodayChatVC") as! DrinkTodayChatVC
                    
                    chatvc.thread = appDelegate().arrayThread[indexPath.row]
                    chatvc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(chatvc, animated: true)
                }else {
                    let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "HistoryChatVC") as! HistoryChatVC
                    chatvc.thread = appDelegate().arrayHistoryThreads[indexPath.row]
                    
                    chatvc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(chatvc, animated: true)
                }
            }else {
                showAlert(title: "Drinks", message: "You must verify you age first.", controller: self)
            }
            
        }
    }
    
    
    //MARK:- API Methods
    //MARK:-
    
    
    func getThreadsForGroups()
    {
        if tableviewGroupMessages.isHidden {
            SwiftLoader.show(true)
        }
        ChatManager.getChatThreads { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                if let arrayThreads = response as? [ChatThread]
                {
                     appDelegate().arrayThread.removeAll()
                    appDelegate().arrayThread.append(contentsOf: arrayThreads)
                    self.tableviewGroupMessages.reloadData()
                    self.updateUI()
                }
            }else{
//                    showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
    func getThreadsForHistory()
    {
        if tableviewGroupMessages.isHidden {
            SwiftLoader.show(true)
        }
        ChatManager.getChatThreadsHistory { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                if let arrayThreads = response as? [ChatThread]
                {
                    appDelegate().arrayHistoryThreads.removeAll()
                    appDelegate().arrayHistoryThreads.append(contentsOf: arrayThreads)
                    self.tableviewGroupMessages.reloadData()
                    self.updateUI()
                }
            }else{
                //                    showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
    
    
    func updateUI(){
        
        var chatArray = [ChatThread]()
        if btnDrinkToday.isSelected {
            chatArray = appDelegate().arrayThread
        }else {
            chatArray = appDelegate().arrayHistoryThreads
        }
        
        if chatArray.count > 0
        {
            tableviewGroupMessages.isHidden = false
            imgViewNoThread.isHidden = true
            
          lblNoThread.isHidden = true
        }else{
            
            tableviewGroupMessages.isHidden = true
            imgViewNoThread.isHidden = false
            lblNoThread.isHidden = false
        }
        
    }
 }
