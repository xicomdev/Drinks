//
//  Constant.swift
//  Drinks
//
//  Created by maninder on 7/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit


let userPlaceHolder =  UIImage(named:"UserPlaceHolder")

let landLogo =  UIImage(named:"LandingLogo")




let APPThemeColor = UIColor(red: 51.0/255.0, green: 151.0/255.0, blue: 241.0/255.0, alpha: 1)
let APP_BarColor = UIColor(red: 51.0/255.0, green: 151.0/255.0, blue: 241.0/255.0, alpha: 1)


let stateLocal = "AppInfo"



let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let alertStoryBoard = UIStoryboard(name: "Alert", bundle: nil)


let defaults = UserDefaults.standard


//API END POINTS

struct Constants {
    struct webURL
    {
        
      //  http://128.199.177.140/drinks/api/
        //static let URLBaseAddress = "http://192.168.1.75/drinks/api/"
        static let URLBaseAddress = "http://128.199.177.140/drinks/api/"
    }
}


let API_GetJobs = "memberJob"
let API_CheckUserExisting = "newCheck"
let API_Register = "registerFacebook"

let arrayBlood = ["A+", "B+", "AB+" , "O+", "O-" ]
let arrayMarriage = ["Single", "Married", "UnMarried" , "Divorced", "Commited" ]
let arrayToabacco = ["ABC", "DEF", "GHI" , "JKL", "MNO" ]
let arraySchool = ["Middle", "Graduate", "Master" , "Ph.d"]
let arrayIncome = ["$ 1000 - 3000", "$ 3000 - 5000", "$ 5000 - 8000" , "$ 8000 - 15000" , "$ 15000 +"]

//let arrayMarriage = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
