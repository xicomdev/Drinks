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

let APP_BlueColor = UIColor(red: 44.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1)

let APP_GaryColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)



let stateLocal = "AppInfo"



let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let alertStoryBoard = UIStoryboard(name: "Alert", bundle: nil)
let msCameraStoryBoard = UIStoryboard(name: "MSCameraGallery", bundle: nil)



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

enum DrinkStatus : Int
{
    case Drinked = 1
    case NotDrinked = 0

    
}
enum GroupBy : String
{
    case My = "MyGroup"
    case Other = "OtherGroup"
}


let API_GetJobs = "memberJob"
let API_CheckUserExisting = "newCheck"
let API_Register = "registerFacebook"
let API_AddGroup = "addGroup"
let API_GetGroups = "getGroups"
let API_Interest = "showInterest"






let arrayBlood = ["A+", "B+", "AB+" , "O+", "O-" ]
let arrayMarriage = ["Single", "Married", "UnMarried" , "Divorced", "Commited" ]
let arrayToabacco = ["ABC", "DEF", "GHI" , "JKL", "MNO" ]
let arraySchool = ["Middle", "Graduate", "Master" , "Ph.d"]
let arrayIncome = ["$ 1000 - 3000", "$ 3000 - 5000", "$ 5000 - 8000" , "$ 8000 - 15000" , "$ 15000 +"]

let arrayDistance : [Int] = [10, 20, 30 , 40 , 50 , 100]

let arrayAge : [String] = ["20 - 25", "26 - 30", "31 - 35" , "36 - 40" , "41 - 45"]
let arrayRelations : [String] = ["Collegues","School Friends","College Friends","Family", "Open"]

let arrayPeople : [Int] = [1, 2, 3 , 4 , 5 ]



//let arrayMarriage = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
//let arrayBlood = [["engName" : "A+","ID" : "1"],["engName" : "B+","ID" : "2"],["engName" : "AB+","ID" : "1"],["engName" : "O+","ID" : "1"],["engName" : "O-","ID" : "1"] ]
