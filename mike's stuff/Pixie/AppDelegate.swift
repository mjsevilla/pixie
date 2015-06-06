//
//  AppDelegate.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Parse stuff
        Parse.setApplicationId("U9G1lVXQ2AVcJTLhtCOGf2Zwk0Q1ZQ47jSHqpoEy",
            clientKey: "Fs4ajHom8FkqZYYv4OJCWUA1Yn2dGhunYViSD6SI")
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotifications()
        }
        
        // Extract the notification data
        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            
            // Create pointers to payload objects
            let recipientName = notificationPayload["rName"] as? String
            let recipientId = notificationPayload["rID"] as? String
            let convoId = notificationPayload["cID"] as? String
            let convo = notificationPayload["convo"] as? PFObject
            
            // Fetch convo object
            convo!.fetchIfNeededInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    // Show conversationVC
                    let convoVC = ConversationViewController()
                    convoVC.convo = convo!
                    convoVC.convoId = convoId
                    convoVC.recipientId = recipientId!
                    convoVC.recipientName = recipientName
                    self.window?.rootViewController?.navigationController?.pushViewController(convoVC, animated: true)
                }
            }
        }
        
        // Facebook stuff
        FBLoginView.self
        FBProfilePictureView.self
        return true
    }
   
   func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
      var wasHandled: Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
      return wasHandled
   }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let rootVC = self.window?.rootViewController as! UINavigationController
        if let initVC = rootVC.topViewController as? InitialViewController {
            initVC.moviePlayer?.play()
        }
        if let searchVC = rootVC.visibleViewController as? SearchViewController {
            searchVC.moviePlayer?.play()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let convo = userInfo["convo"] as? PFObject {
            // Create pointers to payload objects
            let recipientName = userInfo["rName"] as? String
            let recipientId = userInfo["rID"] as? String
            let convoId = userInfo["cID"] as? String
            
            // Fetch convo object
            convo.fetchIfNeededInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    completionHandler(UIBackgroundFetchResult.Failed)
                }
                else if PFUser.currentUser() != nil {
                    // Show conversationVC
                    let convoVC = ConversationViewController()
                    convoVC.convo = convo
                    convoVC.convoId = convoId
                    convoVC.recipientId = recipientId!
                    convoVC.recipientName = recipientName
                    self.window?.rootViewController?.navigationController?.pushViewController(convoVC, animated: true)
                }
                else {
                    completionHandler(UIBackgroundFetchResult.NoData)
                }
            }
        }
        completionHandler(UIBackgroundFetchResult.NoData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

}

