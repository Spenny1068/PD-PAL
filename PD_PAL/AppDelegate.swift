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
// <Oct. 27, 2019, Spencer Lall, Added methods for designs, constraints, and positions for labels and buttons>

import UIKit

/* put global variables in this struct */
struct Setup {
    // color schemes
    static var m_bgColor = UIColor(red: 170/255.0, green: 200/255.0, blue: 226/255.0, alpha: 1.0)   // view controller background color
    
    
}

/* UILabel methods */
extension UILabel {
    
    // applies position, constraint, and design properties to page name labels
    func applyPageNameDesign() {
        self.frame = CGRect(x: -40, y: 40, width: 300, height: 100)            // rectangle coordinates
        self.textAlignment = .center                                           // text alignment
        //self.translatesAutoresizingMaskIntoConstraints = false               // turn off rectangle coordinates
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)              // text font and size
    }
    
    // applies position, constraint, and design properties to page message labels
    func applyPageMsgDesign() {
        self.frame = CGRect(x: -30, y: 70, width: 300, height: 100)            // rectangle coordinates
        self.textAlignment = .center                                           // text alignment
        //msg.translatesAutoresizingMaskIntoConstraints = false                // turn off rectangle coordinates
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)              // text font and size
        self.textColor = UIColor(red: 154/255.0, green: 141/255.0, blue: 141/255.0, alpha: 1.0)     // text color
    }

    func applyQuestionDesign() {
        self.frame = CGRect(x: 36, y: 120, width: 300, height: 150)
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 2
        self.textAlignment = .center
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 25.0)
        self.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
    }
    
    func DescriptionDurationDesign() {
        self.backgroundColor = UIColor.black                   // background color
        self.textColor = UIColor.white
    }
}

/* UIButton methods */
extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.black                    // background color
        self.layer.cornerRadius = self.frame.height / 2         // make button round
        self.setTitleColor(UIColor.white, for: .normal)         // text color
    }
    
    func DesignSelect() {
        self.backgroundColor = UIColor.init(red: 54/255, green: 141/255, blue: 241/255, alpha: 1)
        self.setTitleColor(UIColor.white, for: .normal)                        // text color
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

