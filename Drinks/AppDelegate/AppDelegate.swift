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

import Fabric
import Crashlytics

let dateFormatter = DateFormatter()
let messageDateFormat = DateFormatter()
let lastLoginDateFormat = DateFormatter()





//var descriptionNew: DateFormatter {
//   // return DateFormatter()
//}
//


//
//NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]
//
//NSLocale *locale = [NSLocale currentLocale];
//NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
//
//NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
//


//NSLog(@"country   .   %@",country);

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {

    var arrayThread = [ChatThread]()
    var arrayHistoryThreads = [ChatThread]()
    
    
    var currentThread : ChatThread? = nil

    var timerMessage : Timer!
    
    var window: UIWindow?
    
    var currentlocation : CLLocation?
    var myLocationName : String = ""
    
    
    var appLocation : GroupLocation? = nil
    var locationManager : CLLocationManager?
    
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    
  //  var test1 = 2
  //  var test2 = 4
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        Fabric.with([Crashlytics.self])

        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().previousNextDisplayMode = IQPreviousNextDisplayMode.Default
        
      //  IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreateGroupVC.self]

//        OLKitePrintSDK.setAPIKey("YOUR_TEST_API_KEY", withEnvironment: kOLKitePrintSDKEnvironmentSandbox)

        
        
        
      //  self.swapTwoValues(&test1, &test2)
        
      //  print(test2)
        
        dateFormatter.dateFormat = "YYYY/MM/dd"
        
        messageDateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
       // "last_login" = "2017-10-03 14:52:19";
        
lastLoginDateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
        appLastLoginFormat.dateFormat = "HH:mm a"

      //  datetime = "20/09/2017 06:38 PM";

      Job.saveJobListing()
        
        self.intializeLocationManager()
            self.registerAppPushNotificaiton()
        
        
        timerMessage =  Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (result) in
            
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
        application.applicationIconBadgeNumber = 0
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
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "neophyte.biz..Menu_Venue" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("iCheckbook.sqlite")
        
        print(url)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()


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
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Drinks", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    
    //MARK:- Location Updation
    //MARK:-
    
    
    
    func intializeLocationManager()
    {
        locationManager  = CLLocationManager()
        locationManager!.delegate = self;
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
//        
//        if CLLocationManager.locationServicesEnabled() {
//            print("Device location ON")
//        }else{
//            print("Device location  is OFF")
//            
//        }
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
            self.appLocation = GroupLocation(name: "", lat: Double((self.currentlocation?.coordinate.latitude)!), long: Double((self.currentlocation?.coordinate.longitude)!))
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
                    self.appLocation = GroupLocation(name: addressCurrent, lat: Double((self.currentlocation?.coordinate.latitude)!), long: Double((self.currentlocation?.coordinate.longitude)!))
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
                             chatVC.updateUI()
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
                            chatVC.moveToLastCell()
                        }
                    }
              }
          }
    }
    
    
    
}

