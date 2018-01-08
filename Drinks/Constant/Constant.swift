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
let WT1 =  UIImage(named:"WT1")

let WT2 =  UIImage(named:"WT2")

let WT3 =  UIImage(named:"WT3")
let WT4 =  UIImage(named:"WT4")

let GroupPlaceHolder =  UIImage(named:"GroupPH")



//GroupPH


let APPThemeColor = UIColor(red: 51.0/255.0, green: 151.0/255.0, blue: 241.0/255.0, alpha: 1)
let APP_BarColor = UIColor(red: 51.0/255.0, green: 151.0/255.0, blue: 241.0/255.0, alpha: 1)

let APP_BlueColor = UIColor(red: 44.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1)

let APP_GrayColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
let APP_PlaceHolderColor = UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 194.0/255.0, alpha: 1)




let stateLocal = "AppInfo"



let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let alertStoryBoard = UIStoryboard(name: "Alert", bundle: nil)
let msCameraStoryBoard = UIStoryboard(name: "MSCameraGallery", bundle: nil)



let defaults = UserDefaults.standard


//API END POINTS

struct Constants {
    struct webURL
    {
        //static let URLBaseAddress = "http://192.168.1.75/drinks/api/"
//        static let URLBaseAddress = "http://132.148.135.156/~drinks/api/"
        static let URLBaseAddress = "http://52.196.237.101/drinks/api/"

    }
}




enum DrinkStatus : String
{
    case Drinked = "drinked"
    case NotDrinked = "undrinked"
    case Matched = "confirmed"
}
enum GroupBy : String
{
    case My = "MyGroup"
    case Other = "OtherGroup"
}

enum ReportedStatus : String
{
    case NotReported = "NotReported"
    case Reported = "Reported"
}

enum GroupActionType : String
{
    case Creating = "Creating"
    case Editing = "Editing"
}


let API_GetJobs = "memberJob"
let API_CheckUserExisting = "newCheck"
let API_Register = "registerFacebook"
let API_AddGroup = "addGroup"
let API_DeleteGroup = "deleteGroup"
let API_EditGroup = "editGroup"


let API_GetGroups = "getGroups"
let API_Interest = "showInterest"
let API_ReceivedOffer = "receivedOffers"

let API_SentOffer = "sentOffers"
let API_ReportGroup = "reportGroup"
let API_GetChatThreads = "getThreads"
let API_GetThreadsHistory = "getThreadsHistory"
let API_GetThreadMessages = "getAllMessages"
let API_SendChatMessage = "sendMessage"
let API_LogOut = "logout"
let API_GetSubscriptionPlan = "getMembershipPlanAndTickets"
let API_BuySelectedPlan  = "payByStripe"
let API_RedeemCoupon = "redeemCouponCode"
let API_GetUSerDetail = "getUserInfo"
let API_UpdateUserDetail  = "updateUserInfo"
let API_UpdateNotifications = "updateNotificationInfo"
let API_ageVerify = "updateAgeDocument"
let API_LeaveUser = "deleteUser"

let API_UpdateFbFriends = "updateFacebookFriends"

let API_AboutUs = "http://52.196.237.101/drinks/home/page/about_us"

let API_Help = "http://52.196.237.101/drinks/home/page/help"

let API_Terms = "http://52.196.237.101/drinks/home/page/termsandconditions"

let API_PrivacyPolicy = "http://52.196.237.101/drinks/home/page/privacy"

let API_Faq = "http://52.196.237.101/drinks/home/page/faq"


//MARK:- Apple Pay Merchant ID
let ApplePayDrinksMerchantID = "merchant.com.xicom.drinks" // Fill in your merchant ID here!


let userDefaults = UserDefaults.standard

let arrayBlood = ["A", "B", "O", "AB" ]
var arrayMarriage = ["Single", "Married", "UnMarried" , "Divorced", "Commited" ]
var arrayToabacco = ["ABC", "DEF", "GHI" , "JKL", "MNO" ]
var arraySchool = ["Middle", "Graduate", "Master" , "Ph.d"]
var arrayIncome = ["$ 1000 - 3000", "$ 3000 - 5000", "$ 5000 - 8000" , "$ 8000 - 15000" , "$ 15000 +"]

let arrayDistance : [Int] = [10, 20, 30 , 40 , 50 , 100]

let arrayAge : [String] = ["20 - 25", "26 - 30", "31 - 35" , "36 - 40" , "41 - 45"]
var arrayRelations : [String] = ["Collegues","School Friends","College Friends","Family", "Open"]

let arrayPeople : [Int] = [1, 2, 3 , 4 , 5]
var arrayMsgs = [("HEllo",0),("Hii",1)]


let arySortAge = ["High to low","Low to high"]
let arySortPlace = ["Closer order","In order of distance"]
let arySortOffer = ["Most to least","Less in order"]
let arySortLastLogin = ["Closer order","Oldest first"]
let aryMyPageNavBtns = [(#imageLiteral(resourceName: "account"),"Premium"),(#imageLiteral(resourceName: "cup"),"Buy Tickets"),(#imageLiteral(resourceName: "id_icon"),"Age Verification"),(#imageLiteral(resourceName: "user_tab"),"Profile"),(#imageLiteral(resourceName: "settings"),"Settings"),(#imageLiteral(resourceName: "gifts"),"Coupons"),(#imageLiteral(resourceName: "notificaton"),"Notification"),(#imageLiteral(resourceName: "think"),"Help")]

var aryNotification = ["When I recieved an offer","When matching","When I got a message","Notice"]

var arySettings = [["Logout","Help","Opinions・Inquiries"],["Review Drinks","Terms of Service","Privacy policy","Display based on specified commercial transaction"]]

var aryHelp = ["What is Drinks","In order to use with confidence","Violation report response policy","How to raise the matching rate","About withdrawal"]


