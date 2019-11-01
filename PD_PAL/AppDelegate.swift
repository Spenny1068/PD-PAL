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
// <Nov. 1, 2019, Izyl Canonicato, Added Questionnaire page button and label methods>

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

    // applies questions on Questionnaire storyboard
    func applyQuestionDesign(){
        self.frame = CGRect(x: 36, y: 120, width: 300, height: 150)            // rectangle coordinates
        self.lineBreakMode = .byWordWrapping                                   // Word wrapping
        self.numberOfLines = 2
        self.textAlignment = .center                                           // text alignment
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 25.0)              // text font and size
        self.textColor = UIColor.black
    }
    
    // applies to any input Error message 
    func applyErrorDesign(){
        self.font = UIFont(name:"HelveticaNeue-Italic", size: 15.0)
        self.textColor = UIColor.red
    }
    
    // applies to title on Questionnaire storyboard
    func applyTitle(){
        self.lineBreakMode = .byWordWrapping                                   // Word wrapping
        self.numberOfLines = 2
        self.textAlignment = .center                                           // text alignment
        self.font = UIFont(name:"HelveticaNeue", size: 35.0)                   // text font and size
        self.textColor = UIColor.black
    }
    
    // applies to instructional labels in Questionnaire
    func applyQlabels(){
        self.font = UIFont(name:"HelveticaNeue", size: 25.0)                   // text font and size
        self.textColor = UIColor.black
    }
    
}

/* UIButton methods */
extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.black                                    // background color
        self.layer.cornerRadius = self.frame.height / 2                         // make button round
        self.setTitleColor(UIColor.white, for: .normal)                         // text color
    }
    
    // applies to Questionnaire buttons
    func applyQButton() {
        self.backgroundColor = UIColor.gray                                     // background color
        self.layer.cornerRadius = self.frame.height / 2                         // make button round
        self.setTitleColor(UIColor.white, for: .normal)                         // normal text colour
        self.setTitleColor(UIColor.gray, for: .highlighted)                         // selected text color
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
    }
    
    // applied to Enter button on Registration page
    func applyInputButton(){
        self.backgroundColor = UIColor.black                                    //background color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // text color
    }
    
    // applied to navigation to next Q in Questionnaire
    func applyNextQButton(){
        self.backgroundColor = UIColor(red: 172/255, green: 237/255, blue: 175/255, alpha: 1.0)                //background color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // enabled text colour
        self.setTitleColor(UIColor.gray, for: .disabled)                         // disabled text color
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)         // text font and size

    }
    
    // applied to navigation to previous Q in Questionnaire
    func applyPrevQButton(){
        self.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)              //background color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // enable text colour
        self.setTitleColor(UIColor.gray, for: .disabled)                         // disabled text color
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)         // text font and size
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

