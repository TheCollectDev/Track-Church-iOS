//
//  AppDelegate.swift
//  Track Church
//
//  Created by Lee Watkins on 2016/12/11.
//  Copyright © 2016 Lee Watkins. All rights reserved.
//

import UIKit
import UserNotifications
import TwitterKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FUIAuthDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var authHandler: AuthStateDidChangeListenerHandle?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUITwitterAuth(),
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.providers = providers
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        authHandler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.showHomeView()
            } else {
                self?.showAuthUI()
            }
        }
        Database.database().isPersistenceEnabled = false
        setupFirebaseNotifications(application)
        
        return true
    }
    
    
    func showHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeNavController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            debugPrint("Couldn't get initialViewController of Main Storyboard - something went very wrong")
            return
        }
        setWindowRoot(to: homeNavController)
    }
    
    func showAuthUI() {
        guard let authViewController = FUIAuth.defaultAuthUI()?.authViewController() else {
            debugPrint("Couldn't get Firebase AuthUI - something went very wrong")
            return
        }
        setWindowRoot(to: authViewController)
    }
    
    func setWindowRoot(to navController: UINavigationController) {
        if let window = self.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navController
            }, completion: nil)
        }
    }
    
    func setupFirebaseNotifications(_ application: UIApplication) {
        // This was copied from somewhere when testing how to handle Firebase Invites for Glucode.
        // It could probably be removed until needed
        // I'm going to leave it in for now because we will be receiving notifications at some point.
        
        let msg = Messaging.messaging()
        msg.delegate = self
        
        let token = msg.fcmToken
        print("FCM token: \(token ?? "")")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
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
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let uid = user?.uid {
            NSLog(uid)
        }
        
        // Do something
        if let userName = user?.displayName {
            NSLog(userName)
        }
        
        if let email = user?.email {
            NSLog(email)
        }
        
        if let phone = user?.phoneNumber {
            NSLog(phone)
        }
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
}

