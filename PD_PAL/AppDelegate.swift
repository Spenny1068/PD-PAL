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
// <Nov. 1, 2019, William Huong, Added global variables for UserData, ExerciseDatabase>

import UIKit
import Firebase

/* put global constants in this struct */
struct Global {
    
    /* for routines pages */
    static var IsRoutineExercise = -1   // 0 is categories, 1 is routines, -1 is nil
    static var next_routine_exercise = ""
    static var routine_data: [String] = ["", "", ""]
    static var routine_index = 0
    
    // color schemes
    struct color_schemes {
        static var m_bgColor = UIColor(rgb: 0xECECEC).withAlphaComponent(1.0)        // background color
       
        // blue gradients from dark to light
        static var m_blue1 = UIColor(rgb: 0x30A3FA).withAlphaComponent(1.0)          // Balance
        static var m_blue2 = UIColor(rgb: 0x83C8FD).withAlphaComponent(1.0)          // Strength
        static var m_blue3 = UIColor(rgb: 0x9EC8E6).withAlphaComponent(1.0)          // Launch
        static var m_blue4 = UIColor(rgb: 0xD2E7F7).withAlphaComponent(1.0)          // Ques selected/Cardio
        static var m_lightRed = UIColor(rgb: 0xffcccb).withAlphaComponent(1.0)
        
        static var m_flexButton = UIColor(rgb: 0xF8FBFD).withAlphaComponent(1.0)     // Flexibility
        static var m_lightGrey = UIColor(rgb: 0xBEBEBE).withAlphaComponent(1.0)      // Prev unselected
        static var m_lightGreen = UIColor(rgb: 0x95F98E).withAlphaComponent(1.0)     // Next unselected
        static var m_grey = UIColor(rgb: 0xBFBFBF).withAlphaComponent(1.0)           // Button border
    }
    
    // preset fonts and sizes
    struct text_fonts {
        static var m_exerciseButtonFont = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        static var m_exerciseDescriptionDurationFont = UIFont(name: "HelveticaNeue", size: 20.0)
        static var m_routineButtonFont = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        static var m_timerLabelFont = UIFont(name:"HelveticaNeue-Bold", size: 25.0)
    }
}

/* So we can use hex valued colors */
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

/* UIViewController methods */
extension UIViewController {
    
    /* prints out the view controllers in the navigation stack */
    func logNavigationStack() {
        if let viewControllers = self.navigationController?.viewControllers {
            print ("log navigation stack: ", viewControllers)
            //if viewControllers.contains(where: { return $0 is ExerciseViewController }) {}
        }
    }
    
    // applies constraints for the stack view containing exercise buttons
    func applyStackViewConstraints(SV: UIStackView) {
        NSLayoutConstraint.activate([
            SV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            SV.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            SV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25),
            SV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25),
            SV.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            SV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        ])
    }
    
    // page message
    func show_page_message(s1: String, s2: String) {
        let msg = UILabel()
        let message = s1
        let highlightedWord = s2
        let range = (message as NSString).range(of: highlightedWord)
        let attributedText = NSMutableAttributedString.init(string: message)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: Global.color_schemes.m_blue1, range: range)
        msg.attributedText = attributedText
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
                
        NSLayoutConstraint.activate([
            msg.widthAnchor.constraint(equalToConstant: 350),
            msg.heightAnchor.constraint(equalToConstant: 50),
            msg.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            msg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55)
        ])
    }
    
    // displays exercise description as written in exerciseDB
    func show_exercise_description(string:String, DLabel: UILabel, DText: UILabel) {
        
        // description label
        DLabel.textAlignment = .left                                             // text alignment
        DLabel.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        DLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 25.0)              // text font and size
        DLabel.text = "Description"
        self.view.addSubview(DLabel)

        // description label constraints
        NSLayoutConstraint.activate([
            DLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            DLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -81),
            DLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 415)
        ])
        
        // description text
        DText.textAlignment = .left                                             // text alignment
        DText.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        DText.font = Global.text_fonts.m_exerciseDescriptionDurationFont        // text font and size
        DText.lineBreakMode = .byWordWrapping                                   // Word wrapping
        DText.numberOfLines = 4                                                 // theres space for a maximum of 5 lines
        DText.text = string
        self.view.addSubview(DText)

        // description text constraints
        NSLayoutConstraint.activate([
            DText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            DText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12),
            DText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 450)
        ])
    }
    
    // displays exercise duration as written in exerciseDB
    func show_exercise_duration(string:String) {
        
        // duration label
        let DurationLabel = UILabel()
        DurationLabel.textAlignment = .left                                             // text alignment
        DurationLabel.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        DurationLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 25.0)              // text font and size
        DurationLabel.text = "Duration"
        self.view.addSubview(DurationLabel)

        // duration label constraints
        NSLayoutConstraint.activate([
            DurationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            DurationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -81),
            DurationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 570)
        ])
        
        // duration text
        let DurationText = UILabel()
        DurationText.textAlignment = .left                                             // text alignment
        DurationText.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        DurationText.font = Global.text_fonts.m_exerciseDescriptionDurationFont     // text font and size
        DurationText.lineBreakMode = .byWordWrapping                                   // Word wrapping
        DurationText.numberOfLines = 2                                                 // theres space for a maximum of 2 lines
        DurationText.text = string
        self.view.addSubview(DurationText)

        // duration text constraints
        NSLayoutConstraint.activate([
            DurationText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            DurationText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -81),
            DurationText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 605)
        ])
    }
    
    // applies constraints for a single exercise button
    func applyExerciseButtonConstraint(button: UIButton) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 304),
            button.heightAnchor.constraint(equalToConstant: 81),
            button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
        ])
    }
    
    // applies constraints for a single routine button
    func applyRoutineButtonConstraint(button: UIButton) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 150),
            button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 38),
            button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -38),
        ])
    }
    
    // applies constraints for a single exercise button
    func applyExerciseLabelConstraint(label: UILabel) {
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 150),
            label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 38),
            label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -38),
        ])
    }
}

/* UILabel methods */
extension UILabel {
    
    // applies position, constraint, and design properties to page message labels
    func applyPageMsgDesign() {
        self.textAlignment = .left                                             // text alignment
        self.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        self.font = UIFont(name:"HelveticaNeue-Bold", size: 26.0)              // text font and size
    }
    
    // applies questions on Questionnaire storyboard
    func applyQuestionDesign(){
        self.frame = CGRect(x: 36, y: 120, width: 300, height: 150)            // rectangle coordinates
        self.lineBreakMode = .byWordWrapping                                   // Word wrapping
        self.numberOfLines = 3
        self.textAlignment = .center                                           // text alignment
        self.font = Global.text_fonts.m_routineButtonFont                      // text font and size
        self.textColor = UIColor.black
    }
    
    func applyExerciseLabelDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false                 // turn off rectangle coordinates
        self.textAlignment = .center                                           // text alignment
        self.font = UIFont(name:"HelveticaNeue", size: 25.0)                    // text font and size
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
    
    func DescriptionDurationDesign() {
        self.backgroundColor = UIColor.black                   // background color
        self.textColor = UIColor.white                          // text color
    }
    
    func timerAndSetsDesign() {
        self.textAlignment = .center
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.font = Global.text_fonts.m_timerLabelFont
        //self.layer.backgroundColor = UIColor.white.cgColor
        //self.layer.cornerRadius = self.frame.width/2
    }
    
    // frames for timer and sets labels
    func applyTimerLabelFrame() { self.frame = CGRect(x: 210, y: 425, width: 150, height: 125) }
    func applySetsLabelFrame() { self.frame = CGRect(x: 30, y: 425, width: 150, height: 125) }
}

/* UIButton methods */
extension UIButton {
    
    /* design for buttons on categories page */
    func categoryButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false               // turn on constraints

        // design
        self.layer.cornerRadius = 25                                         // rounded edges
        self.layer.borderWidth = 2                                           // border width in points
        self.layer.borderColor = Global.color_schemes.m_grey.cgColor         // border color
        self.clipsToBounds = true                                            // confines bounds of view
        
        // text
        self.setTitleColor(UIColor.black, for: .normal)                      // button text color
        self.contentHorizontalAlignment = .center                            // button text aligned center of horizontal
        self.contentVerticalAlignment = .bottom                              // button text aligned bottom of self
        
        self.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20, bottom: 10.0, right: 20.0)
    }
    
    func exerciseButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false               // turn on constraints

        // design
        self.layer.cornerRadius = 40                                         // rounded edges
        self.layer.borderWidth = 3                                           // border width in points
        self.layer.borderColor = Global.color_schemes.m_grey.cgColor         // border color
        
        // text
        self.setTitleColor(UIColor.black, for: .normal)                      // button text color
        self.contentHorizontalAlignment = .center                              // button text aligned center of horizontal
        self.contentVerticalAlignment = .center                              // button text aligned bottom of self
        self.titleLabel?.font = Global.text_fonts.m_exerciseButtonFont
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 80)
        
        // play button image
        //let exerciseImage = UIImage(named: "ppp.png")/
        self.setImage(UIImage(named: "Playbutton") , for: UIControl.State.normal)
        self.tintColor = UIColor.lightGray
        self.imageEdgeInsets = UIEdgeInsets(top: 20.0, left:260, bottom: 20.0, right: 0)
    }
        
    func routineButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false               // turn on constraints

        // design
        self.layer.cornerRadius = 45                                         // rounded edges
        self.layer.borderWidth = 2                                           // border width in points
        self.layer.borderColor = Global.color_schemes.m_grey.cgColor         // border color
        self.clipsToBounds = true                                            // confines bounds of view
        
        // text
        self.setTitleColor(UIColor.black, for: .normal)                      // button text color
        //self.setTitleColor(UIColor.gray, for: .selected)
        self.contentHorizontalAlignment = .center                            // button text aligned center of horizontal
        self.contentVerticalAlignment = .center                              // button text aligned bottom of self
        self.titleLabel?.font = Global.text_fonts.m_routineButtonFont       // button text font
        self.titleLabel?.numberOfLines = 2                                  // button text number of lines
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
    }
    
    func timerButtonDesign() {

        // design
        self.layer.cornerRadius = 30                                         // rounded edges
        self.layer.borderWidth = 3                                           // border width in points
        self.layer.borderColor = Global.color_schemes.m_grey.cgColor         // border color

        // text
        self.setTitleColor(UIColor.black, for: .normal)                      // button text color
        self.contentHorizontalAlignment = .center                            // button text aligned center of horizontal
        self.contentVerticalAlignment = .center                              // button text aligned bottom of self
        self.titleLabel?.font = Global.text_fonts.m_exerciseButtonFont
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0.0)
    }
    
    // applies to Questionnaire buttons
    func applyQButton() {
        self.backgroundColor = Global.color_schemes.m_grey                      // background color
        self.layer.cornerRadius = self.frame.height / 2                         // make button round
        self.setTitleColor(UIColor.white, for: .normal)                         // normal text colour
        self.setTitleColor(UIColor.gray, for: .selected)                        // selected text color
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25.0)
    }
    
    // applied to Enter button on Registration page
    func applyInputButton(){
        self.backgroundColor = UIColor.black                                    //background color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // text color
    }
    
    // applied to navigation to next Q in Questionnaire
    func applyNextQButton(){
        self.backgroundColor = Global.color_schemes.m_blue1                     //background color
        self.layer.borderWidth = 2                                              // border width in points
        self.layer.borderColor = Global.color_schemes.m_grey.cgColor            // border color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // enabled text colour
        self.setTitleColor(UIColor.gray, for: .disabled)                        // disabled text color
        self.titleLabel?.font = Global.text_fonts.m_routineButtonFont   // text font and size
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 40, bottom: 0.0, right: 40)     // text allignment
    }
    
    // applied to navigation to previous Q in Questionnaire
    func applyPrevQButton(){
        self.backgroundColor = Global.color_schemes.m_grey                      //background color
        self.layer.cornerRadius = self.frame.height / 4                         // make button rounded
        self.setTitleColor(UIColor.white, for: .normal)                         // enable text colour
        self.titleLabel?.font = Global.text_fonts.m_routineButtonFont           // text font and size
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 40, bottom: 0.0, right: 40)     // text allignment
    }
    
    /* home button on navigation bar */
    func applyHomeButton(){
        self.setImage(UIImage(named: "SmallLogo"), for: .normal)
        self.frame = CGRect(x: 0, y:0, width: 10, height: 5)
    }
    
    /* frames for the three different timer buttons */
    func applyDefaultTimerButtonFrame() { self.frame = CGRect(x: 36, y: 575, width: 300, height: 75) }
    func applyLeftTimerButtonFrame() { self.frame = CGRect(x: 10, y: 575, width: 175, height: 75) }
    func applyRightTimerButtonFrame() { self.frame = CGRect(x: 190, y: 575, width: 175, height: 75) }
}

/* UISlider methods */
extension UISlider {
    
    //Questionnaire slider styling
    func questionnaireSlider(){
        self.minimumTrackTintColor = Global.color_schemes.m_blue2               // custom track colour tint
        self.setThumbImage(UIImage(named: "Slider"), for: .normal)              // custom thumb slider image
    }
}

/* UIImageVIew methods */
extension UIImageView{
    func roundImages(){
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.frame.width / 0.25
        self.clipsToBounds = true
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Initialize Firebase components
        FirebaseApp.configure()
        
        //On cold start, if user does not exist, enter Questionnaire storyboard
        if(!global_UserData.User_Exists()){
            print("USERNMAE: " + global_UserData.Get_User_Data().UserName)
            //global_UserData.Clear_UserInfo_Database()
            let view = UIStoryboard(name: "Questionnare", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
            window?.rootViewController = view
        }
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

//Global instances of our classes
let global_UserData = UserData()
let global_ExerciseData = ExerciseDatabase()
let global_StepTracker = StepCount()
let global_UserDataFirestore = UserDataFirestore()
