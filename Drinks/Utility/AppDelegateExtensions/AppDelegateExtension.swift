//
//  AppDelegateExtension.swift
//  Drinks
//
//  Created by maninder on 9/12/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UserNotifications


extension AppDelegate {
    
    
    fileprivate func topViewControllerWithRootViewController(_ rootViewController:UIViewController) -> UIViewController {
        
        if (rootViewController is UITabBarController) {
            
            let tabBarController:UITabBarController = rootViewController as! UITabBarController
            return  self.topViewControllerWithRootViewController(tabBarController.selectedViewController!)
            
        }else if (rootViewController is UINavigationController) {
            let tabBarController:UINavigationController = rootViewController as! UINavigationController
            return  self.topViewControllerWithRootViewController(tabBarController.visibleViewController!)
            
        }else if ((rootViewController.presentedViewController) != nil) {
            
            let presentedViewController: UIViewController = rootViewController
            return  self.topViewControllerWithRootViewController(presentedViewController)
        }else{
            return rootViewController;
        }
    }
    
    func topViewController() -> UIViewController {
        return self.topViewControllerWithRootViewController((UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
    
    
    
    
    
    
    
    
    func deviceUniqueIdentifier() -> String {
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
   
        var strApplicationUUID = SSKeychain.password(forService: appName, account: "incoding")
        if (strApplicationUUID == nil)
        {
            strApplicationUUID = UIDevice.current.identifierForVendor?.uuidString;
            // strApplicationUUID = UIDevice.currentDevice.identifierForVendor?.UUIDString;
            SSKeychain.setPassword(strApplicationUUID, forService: appName, account: "incoding")
        }
        return strApplicationUUID!;
    }
    
    class var appDelegate: AppDelegate {
        get {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return delegate
        }
    }
    
    class var app: UIApplication {
        get {
            return UIApplication.shared
        }
    }
    
    func unregisterAppPushNotifications(){
     
        AppDelegate.app.registerForRemoteNotifications();
    }
    
    func registerAppPushNotificaiton() {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [UNAuthorizationOptions.sound , UNAuthorizationOptions.alert,UNAuthorizationOptions.badge], completionHandler: { (isSuccess, error) in
                if (error == nil){
                    // let settings = UNNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    //  UIApplication.shared.registerUserNotificationSettings(settings)
                    AppDelegate.app.registerForRemoteNotifications();
                }
            })
        }else{
            AppDelegate.app.registerForRemoteNotifications()
        }
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let pushToken = String(format: "%@", deviceToken as CVarArg)
        let characterSet: CharacterSet = CharacterSet.init(charactersIn: "<>")
        let strDeviceToken: String? = pushToken.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        userDefaults.set(strDeviceToken, forKey: "DeviceToken")
        userDefaults.synchronize()
        //   INSInstaplyAccountManager.shared().apnsToken = deviceToken
        
    }
    
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("\(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let dict: Dictionary? = userInfo as? Dictionary<String,AnyObject>
        if dict != nil
        {
            if  let pushData = dict?["aps"] as?  Dictionary<String,Any>
            {
                let dictData =  pushData["data"]  as!  Dictionary<String,Any>
                //                let thread = ChatThread(groupThread: dictData)
                if self.window?.topMostController() is MSTabBarController
                {
                    let topVC =  (self.window?.topMostController() as! MSTabBarController).selectedViewController as! UINavigationController
                    
                    if dictData["push_type"] as! String == "Message" && dictData["push_type"] as! String == "DrinkedGroupAccepted"{
                        if !(topVC.visibleViewController is DrinkTodayChatVC) && !(topVC.visibleViewController is HistoryChatVC) && !(topVC.visibleViewController is MessageVC){
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 2
                            self.window?.rootViewController = tabBarController
                        }
                    }else if dictData["push_type"] as! String == "DrinkedGroup" {
                        if !(topVC.visibleViewController is OfferVC) {
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 1
                            self.window?.rootViewController = tabBarController
                        }
                    }else if dictData["push_type"] as! String == "CouponUsed" {
                        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                        tabBarController.selectedIndex = 3
                        self.window?.rootViewController = tabBarController
                    }else {
                        if !(topVC.visibleViewController is HomeVC) {
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 0
                            self.window?.rootViewController = tabBarController
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dict : Dictionary? = response.notification.request.content.userInfo as? Dictionary<String,Any>
        if dict != nil{
            if  let pushData = dict?["aps"] as?  Dictionary<String,Any>
            {
                let dictData =  pushData["data"]  as!  Dictionary<String,Any>
//                let thread = ChatThread(groupThread: dictData)
                
                    if dictData["push_type"] as! String == "Message" || dictData["push_type"] as! String == "DrinkedGroupAccepted"{
                        
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 2
                            self.window?.rootViewController = tabBarController
                        
                    }else if dictData["push_type"] as! String == "DrinkedGroup" {
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 1
                            self.window?.rootViewController = tabBarController
                    }else if dictData["push_type"] as! String == "CouponUsed" {
                        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                        tabBarController.selectedIndex = 3
                        self.window?.rootViewController = tabBarController
                    }else {
                            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MSTabBarController") as! MSTabBarController
                            tabBarController.selectedIndex = 0
                            self.window?.rootViewController = tabBarController
                    }
                    
//                    if  topVC.visibleViewController  is DrinkTodayChatVC {
//                        let openedVC =  topVC.visibleViewController  as! DrinkTodayChatVC
//                        if openedVC.thread.ID == thread.ID
//                        {
//                            openedVC.tblChat.reloadData()
//                            openedVC.moveToLastCell()
//
//                        }else{
//                            self.openChatVC(thread: thread)
//                        }
//                    }else{
//                        self.openChatVC(thread: thread)
//                    }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dict : Dictionary? = notification.request.content.userInfo as? Dictionary<String,Any>
        if dict != nil{
            if dict?["aps"] != nil
            {
                completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
            }
            
        }
        
    }
    
    
    func openChatVC(thread : ChatThread){
        
        let viewController: UIViewController? = self.topViewController() // optional
        var navController: UINavigationController? = nil;
        
        if viewController is UINavigationController {
            navController = viewController as? UINavigationController
        }else {
            navController = viewController!.navigationController
        }

        
        if navController == nil{
            navController = UINavigationController()
        }
        
        let objectVC = mainStoryBoard.instantiateViewController(withIdentifier: "DrinkTodayChatVC") as! DrinkTodayChatVC
        objectVC.thread = thread
        navController?.pushViewController(objectVC, animated: true)
    }
    
    
}

