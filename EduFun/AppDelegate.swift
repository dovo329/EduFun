//
//  AppDelegate.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @objc func animateToViewController(destVCEnum: UInt32, srcVCEnum: UInt32)
    {
        var destVC : UIViewController!
        
        let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds
        print("bounds.width=\(bounds.width) height=\(bounds.height)")
        
        if destVCEnum == ViewControllerEnum.MrSkunk
        {
            //overlayView.transform = CGAffineTransformMakeRotation(-π/2)
            //overlayView.frame = CGRectMake(0, 0, 480, 320)
            destVC = MrSkunkViewController()
        }
        else if destVCEnum == ViewControllerEnum.CardMatching
        {
            overlayView.transform = CGAffineTransform(rotationAngle: π/2)
            overlayView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
            destVC = MemoryGameViewController()
        }
        else if destVCEnum == ViewControllerEnum.ColoringBook
        {
            destVC = ColoringBookViewController()
        }
        else if destVCEnum == ViewControllerEnum.TitleScreen
        {
            if (srcVCEnum == ViewControllerEnum.CardMatching)
            {
                overlayView.transform = CGAffineTransform(rotationAngle: -π/2)
                overlayView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
            }
            else if (srcVCEnum == ViewControllerEnum.ColoringBook)
            {
                overlayView.transform = CGAffineTransform(rotationAngle: 0)
                overlayView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height) // why?  but I must or else
            }
            destVC = TitleScreenViewController()
        }
        else if destVCEnum == ViewControllerEnum.About
        {
            destVC = AboutViewController()
        }
        else
        {
            fatalError("unknown view controller enum passed")
        }
        
        destVC.view.addSubview(overlayView)
        window!.rootViewController = destVC;
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseInOut,
            animations:
            { () -> Void in
                overlayView.alpha = 0.0
            },
            completion:
            { (_) -> Void in
                overlayView.removeFromSuperview()
            }
        )
    }
    
    /*func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }*/
    
    func applicationDidFinishLaunching(_ application: UIApplication) {

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        
        //window!.rootViewController = UINavigationController(rootViewController: ColoringBookViewController())
        //window!.rootViewController = EmitterTestViewController()
        //window!.rootViewController = MemoryGameViewController()
        window!.rootViewController = TitleScreenViewController()
        //window!.rootViewController = ColoringBookViewController()
        //var navigationController = UINavigationController(rootViewController: TitleScreenViewController())
        //var navigationController = OrientationNavigationController(rootViewController: TitleScreenViewController())
        //navigationController.navigationBarHidden = true
        //window!.rootViewController = navigationController
        //var tabBarController = UITabBarController()
        //window!.rootViewController = tabBarController
        //window!.rootViewController = ContainerViewController()
        window!.makeKeyAndVisible()
    }
    
    /*- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
    }*/

    func applicationWillResignActive(_ application: UIApplication) {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dougsapps.CollectionViewTest" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CollectionViewTest", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CollectionViewTest.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error!), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error!), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
}

