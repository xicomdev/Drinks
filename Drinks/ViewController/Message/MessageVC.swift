//
//  MessageVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MessageVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    
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
        
 
       // self.getThreadsForGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableviewGroupMessages.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnDrinkTodayAction(_ sender: AnyObject) {
        btnDrinkToday.isSelected = true
        btnHistory.isSelected = false
        btnDrinkToday.backgroundColor = APP_BlueColor
        btnHistory.backgroundColor = APP_GrayColor
        tableviewGroupMessages.reloadData()
    }

    @IBAction func btnHistoryAction(_ sender: AnyObject) {
        btnHistory.isSelected = true
        btnDrinkToday.isSelected = false
        btnDrinkToday.backgroundColor = APP_GrayColor
        btnHistory.backgroundColor = APP_BlueColor
        tableviewGroupMessages.reloadData()
    }
    
    //MARK:- TableView Delegates
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate().arrayThread.count
            
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
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if btnDrinkToday.isSelected {
            let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "DrinkTodayChatVC") as! DrinkTodayChatVC
           // chatvc.thread = appDelegate().arrayThread[indexPath.row]
            
            appDelegate().currentThread = appDelegate().arrayThread[indexPath.row]
            chatvc.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(chatvc, animated: true)
        }else {
            let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "HistoryChatVC") as! HistoryChatVC
            chatvc.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(chatvc, animated: true)
        }
    }
    
    
    //MARK:- API Methods
    //MARK:-
    
    
    func getThreadsForGroups()
    {
        
        ChatManager.getChatThreads { (success, response, strError) in
            if success
            {
                if let arrayThreads = response as? [ChatThread]
                {
                     appDelegate().arrayThread.removeAll()
                    appDelegate().arrayThread.append(contentsOf: arrayThreads)
                    self.tableviewGroupMessages.reloadData()
                }
            }else{
        //showAlert(title: "Drinks", message: strError!, controller: self)
            }
        }
    }
 }
