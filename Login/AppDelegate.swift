//
//  AppDelegate.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 28/09/23.
//

import UIKit
import GoogleSignIn
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        UITabBar.appearance().barTintColor = .secondary
        //        UITabBar.appearance().tintColor = .tertiary
        //guard let windowScene = (scene as? UIWindowScene) else { return }

        //window = UIWindow(frame: UIScreen.main.bounds)
        /*
        let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: MainNavigationController.identifier) as? MainNavigationController
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: ViewController.identifier) as? ViewController else {
                    print("View controller failed")
                    return
                }
                initialViewController?.viewControllers = [viewController]
            } else {
                // Show the app's signed-in state.
                guard let homeTabBarController = mainStoryboard.instantiateViewController(withIdentifier: HomeTabBarController.identifier) as? HomeTabBarController else {
                    print("Home tab bar controller failed")
                    return
                }
                initialViewController?.viewControllers = [homeTabBarController]
            }
            self.window?.rootViewController = initialViewController
            //self.window?.windowScene = windowScene
            self.window?.makeKeyAndVisible()
        }
         */
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.black
//        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithTransparentBackground()
//        navigationBarAppearance.backgroundColor = .appPrimaryColour
        //navigationBarAppearance.
        //UINavigationBar.appearance().
        // Setting navigation bar appearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Setting tab bar tint color
        UITabBar.appearance().tintColor = .appSecondaryColour
        
        return true
         
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "SwiggyReplicaCoreData")
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
    
}

