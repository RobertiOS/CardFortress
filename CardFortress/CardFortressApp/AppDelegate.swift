//
//  AppDelegate.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import LeakedViewControllerDetector

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        LeakedViewControllerDetector.onDetect() { leakedViewController, leakedView, message in
            if let leakedViewController {
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                  "EventType": "ViewController leaked",
                  "View controller title": leakedViewController.title ?? "",
                ])
            }
            
            if let leakedView {
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                  "EventType": "View leaked",
                ])
            }
            
            #if DEBUG
            return true //show warning alert dialog
            #else
            //here you can log warning message to a server, e.g. Crashlytics
            return false //don't show warning to user
            #endif
        }
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

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("background")
    }

}

