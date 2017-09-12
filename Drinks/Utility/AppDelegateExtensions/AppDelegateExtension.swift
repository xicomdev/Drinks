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
            let info: Dictionary? = dict!["info"] as? Dictionary<String,AnyObject>
            if info != nil {
                
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let dict : Dictionary? = response.notification.request.content.userInfo as? Dictionary<String,Any>
        if dict != nil{
            
            
            print(dict)
            //        if dict?["aps"] != nil
            //        {
            //            let dictInner = dict?["aps"] as? Dictionary<String, Any>
            //            if dictInner?["info"] != nil {
            //                let objectData = dictInner?["info"]  as! Dictionary<String ,Any>
            //                let dictJson = objectData["JsonData"] as! Dictionary<String ,Any>
            //                let strAPIKey = dictJson["ApiKey"] as! NSNumber
            //                let strSessionKey = dictJson["SessionKey"] as! String
            //                let strToken = dictJson["Token"] as! String
            //                APIVideoKey = strAPIKey.description
            //                VideoSessionID = strSessionKey
            //                VideoToken = strToken
            //
            //                let viewCall =   showCallingView()
            //                self.window?.rootViewController?.view.window?.addSubview(viewCall)
            ////                let controller: CallVideoVC = CallVideoVC(nibName: "CallVideoVC", bundle: nil)
            ////                controller.apiKey = strAPIKey.description
            ////                controller.sessionID = strSessionKey
            ////                controller.token = strToken
            ////                (self.window?.rootViewController)!.present(controller, animated: true, completion: nil)
            //
            //            }
            //
            //        }
            
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dict : Dictionary? = notification.request.content.userInfo as? Dictionary<String,Any>
        if dict != nil{
            if dict?["aps"] != nil
            {
                //                    let dictInner = dict?["aps"] as? Dictionary<String, Any>
                //                   if dictInner?["info"] != nil {
                //                    let objectData = dictInner?["info"]  as! Dictionary<String ,Any>
                //                    let dictJson = objectData["JsonData"] as! Dictionary<String ,Any>
                //                       let strAPIKey = dictJson["ApiKey"] as! NSNumber
                //                        let strSessionKey = dictJson["SessionKey"] as! String
                //                        let strToken = dictJson["Token"] as! String
                //                    APIVideoKey = strAPIKey.description
                //                    VideoSessionID = strSessionKey
                //                    VideoToken = strToken
                //
                //
                //                    print(APIVideoKey)
                //                    print(VideoSessionID)
                //                    print(VideoToken)
                //  let viewCall =   showCallingView()
                // self.window?.rootViewController?.view.window?.addSubview(viewCall)
                
            }
            
        }
        
    }
    
    
}

