//
//  AppDelegate.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

// REVISION HISTORY:
// <Date, Name, Changes made>
// <Oct. 26, 2019, Spencer Lall, Added struct for global variables>

import UIKit

/* put global variables in this struct */
struct Setup {
    // color schemes
    static var m_bgColor = UIColor(red: 170/255.0, green: 200/255.0, blue: 226/255.0, alpha: 1.0)
    
    
    //static let m_pageNameSize = 30.0
   // static let m_subHeaderNameSize = 15.0
    
}

// UILabel methods
extension UILabel {
    func applyPageNameDesign() {
        self.frame = CGRect(x: -40, y: 50, width: 300, height: 100)            // rectangle coordinates
        self.textAlignment = .center                                           // text alignment
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
    }
    
    func applyPageMsgDesign() {
        self.frame = CGRect(x: -30, y: 80, width: 300, height: 100)
        self.textAlignment = .center                                           // text alignment
        //msg.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        self.textColor = UIColor(red: 154/255.0, green: 141/255.0, blue: 141/255.0, alpha: 1.0)
    }
}
// UIButton methods
extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    }
}

