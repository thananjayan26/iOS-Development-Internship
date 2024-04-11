//
//  SceneDelegate.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 28/09/23.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
            
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // To set app appearance based on user preference
        if getAppearanceStyle() == 0 {
            window?.overrideUserInterfaceStyle = .light
        } else {
            window?.overrideUserInterfaceStyle = .dark
        }
        
        let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: MainNavigationController.identifier) as? MainNavigationController
        
        // Checking is logged in
        if AppCoreData.instance.getUserInformation() != nil {
            guard let homeTabBarController = mainStoryboard.instantiateViewController(withIdentifier: HomeTabBarController.identifier) as? HomeTabBarController else {
                print("Home tab bar controller failed")
                return
            }
            // Setting entry point to home of app
            initialViewController?.viewControllers = [homeTabBarController]
            
        } else {
            // Checking if user logged in using Google sign in
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
            }
        }
        
        /*
        if checkLoggedInState() {
            guard let homeTabBarController = mainStoryboard.instantiateViewController(withIdentifier: HomeTabBarController.identifier) as? HomeTabBarController else {
                print("Home tab bar controller failed")
                return
            }
            initialViewController?.viewControllers = [homeTabBarController]
        } else {
            guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: ViewController.identifier) as? ViewController else {
                print("View controller failed")
                return
            }
            initialViewController?.viewControllers = [viewController]
        }
         */
        
        // Setting app's root view controller
        window?.rootViewController = initialViewController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

