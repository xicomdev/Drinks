//
//  MessageVC.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MessageVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnDrinkToday: UIButton!
    @IBOutlet weak var tableviewGroupMessages: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        btnDrinkToday.isSelected = true
        btnDrinkToday.backgroundColor = APP_BlueColor
        
        tableviewGroupMessages.registerNibsForCells(arryNib: ["DrinkTodayCell","HistoryMsgCell"])
        tableviewGroupMessages.tableFooterView = UIView()
        tableviewGroupMessages.delegate = self
        tableviewGroupMessages.dataSource = self
        tableviewGroupMessages.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if btnDrinkToday.isSelected {
            return 160
        }else {
            return 94
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnDrinkToday.isSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTodayCell", for: indexPath) as! DrinkTodayCell
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryMsgCell", for: indexPath) as! HistoryMsgCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if btnDrinkToday.isSelected {
            let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "DrinkTodayChatVC") as! DrinkTodayChatVC
            self.navigationController?.pushViewController(chatvc, animated: true)
        }else {
            let chatvc = mainStoryBoard.instantiateViewController(withIdentifier: "HistoryChatVC") as! HistoryChatVC
            self.navigationController?.pushViewController(chatvc, animated: true)
        }
    }
    
 }
