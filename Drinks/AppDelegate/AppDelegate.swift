//
//  AppDelegate.swift
//  Drinks
//
//  Created by maninder on 7/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

let dateFormatter = DateFormatter()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {

    var arrayThread = [ChatThread]()
    
    var currentThread : ChatThread? = nil

    var timerMessage : Timer!
    
    var window: UIWindow?
    
    var currentlocation : CLLocation?
    var myLocationName : String = ""
    
    
    var appLocation : GroupLocation? = nil
    var locationManager : CLLocationManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().previousNextDisplayMode = IQPreviousNextDisplayMode.Default
        
      //  IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreateGroupVC.self]

        
        dateFormatter.dateFormat = "YYYY/MM/dd"

      Job.saveJobListing()
        
        self.intializeLocationManager()
            self.registerAppPushNotificaiton()
        
        
        timerMessage =  Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (result) in
          self.getUpdatedMessages()
        })
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme!  == "fb337990433305863" {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL! , sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return false
        
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Drinks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
            let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:- Location Updation
    //MARK:-
    
    
    
    func intializeLocationManager()
    {
        locationManager  = CLLocationManager()
        locationManager!.delegate = self;
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        
        if CLLocationManager.locationServicesEnabled() {
            print("Device location OFF")
        }else{
            print("Device location  is not OFF")
            
            // print(locationUpdateAvalilable())
        }
    }
    
    
    func locationUpdateAvalilable() -> Bool {
        let status:CLAuthorizationStatus =  CLLocationManager.authorizationStatus()
        switch (status) {
        case .authorizedAlways:
            return true;
        case .authorizedWhenInUse:
            return true;
        case .notDetermined:
            return false;
        case .denied:
            return false;
        case .restricted:
            return false;
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations.last
        if (location == nil){
            return;
        }else{
            print("Getting location fine")
            self.currentlocation = location!
            self.getLocationNameFromLatAndLong()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .authorizedAlways:
            return ;
        case .authorizedWhenInUse:
            return ;
        case .notDetermined:
            return ;
        case .denied:
            //SHow Alert when location setiiing has been changed
           // HSShowAlertView("Who's In", message: "Please enable your location for app.")
            return ;
        case .restricted:
            return ;
        }
        
    }
    
    func getLocationNameFromLatAndLong() {
        if currentlocation != nil{
            CLGeocoder().reverseGeocodeLocation(currentlocation!, completionHandler: {(placemarks, error) -> Void in
                var addressCurrent = String()
                
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    
                    /// print(pm.locality)
                    // print(pm.addressDictionary)
                    //print(pm.administrativeArea)
                    
                    if let dictAddress = pm.addressDictionary as? Dictionary <String, AnyObject>{
                        let subLocatlity = dictAddress["SubLocality"] as? String
                        if subLocatlity != nil{
                            addressCurrent = subLocatlity!
                        }
                        
                        let cityName = dictAddress["City"] as? String
                        if cityName != nil{
                            addressCurrent = addressCurrent + ", " + cityName!
                        }
                    }
                    self.myLocationName = addressCurrent
                    self.appLocation = GroupLocation(name: addressCurrent, lat: (self.currentlocation?.coordinate.latitude)!.description, long: (self.currentlocation?.coordinate.longitude)!.description)
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    

    
    
    //MARK:- Get Updated Messages
    //MARK:-
    
    func getUpdatedMessages(){
        
        if self.window?.topMostController() is MSTabBarController
        {
            let topVC =  (self.window?.topMostController() as! MSTabBarController).selectedViewController as! UINavigationController
            if topVC.visibleViewController  is DrinkTodayChatVC {
                self.APIGetMessagesForThread()
            }else{
                      self.getThread()
            }
        }
    }
    
    
    func getThread()
    {
        ChatManager.getChatThreads { (success, response, strError) in
            if success
            {
                if let arrayThreads = response as? [ChatThread]
                {
                 
                    self.arrayThread.removeAll()
                   self.arrayThread.append(contentsOf: arrayThreads)
                    
                    
                    if self.window?.topMostController() is MSTabBarController
                    {
                        let topVC =  (self.window?.topMostController() as! MSTabBarController).selectedViewController as! UINavigationController
                        if topVC.visibleViewController  is MessageVC {
                            
                            let chatVC = topVC.visibleViewController   as! MessageVC
                            chatVC.tableviewGroupMessages.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
    
    func APIGetMessagesForThread()
    {
        self.currentThread?.getAllMessages { (isSuccess, response, error) in
                if isSuccess
                  {
                    
                    
                    if self.window?.topMostController() is MSTabBarController
                    {
                        let topVC =  (self.window?.topMostController() as! MSTabBarController).selectedViewController as! UINavigationController
                        if  topVC.visibleViewController  is DrinkTodayChatVC {
                            let chatVC = topVC.visibleViewController   as! DrinkTodayChatVC
                            chatVC.tblChat.reloadData()
//                            self.perform(#selector(DrinkTodayChatVC.scrollToBottomInitial), with: nil, afterDelay: 0.1)

                        }
                    }
              }
          }
    }
    
    
    
}

