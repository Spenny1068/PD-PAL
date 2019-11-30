//
//  SettingsViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>
// <November 16, 2019, Julia Kim, added a sw to ask for user permission to push user data to cloud, adding a button to allow user to delete their data>
// <November 17, 2019, William Huong, delete button now also clears data from Firebase>

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
    
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)

    @IBOutlet weak var cloudSWLabel: UILabel!
    @IBOutlet weak var cloudSW: UISwitch!
    @IBOutlet weak var deleteData: UIButton!
    @IBOutlet weak var updateProfile: UIButton!
    @IBOutlet weak var linkWebsiteBtn: UIButton!
    let userDB = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        Global.questionnaire_index = 1
        /* page message */
        self.show_page_message(s1: "Change Your Settings!", s2: "Settings")
        cloudSW.isOn = userDB.Get_User_Data().FirestoreOK
        cloudSW.setOn(userDB.Get_User_Data().FirestoreOK, animated: true) //set initial switch status to false
        
        deleteData.settingsButtonDesign()
        updateProfile.settingsButtonDesign()
        linkWebsiteBtn.settingsButtonDesign()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
    
    //opens safari within the app to access the web component of PD PAL
    @IBAction func accessWebsite(_ sender: Any){
        var webUserName = "tester" //default test account
        
        //check that the current username exists in firebase. If not, just use a tester account as a sample
        //print("Name Verified: \(global_UserData.Get_User_Data().NameVerified)")
        //print("FireStoreOK: \(global_UserData.Get_User_Data().FirestoreOK)")
        
        if global_UserData.Get_User_Data().FirestoreOK {
            webUserName = global_UserData.Get_User_Data().UserName //local DB username also exists in firebase, therefore can access the website
        }
        
        if let url = URL(string: "https://pd-pal.web.app/userDisplay/?name=\(webUserName)"){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if cloudSW.isOn{
            //set the switch to "on"
            cloudSW.setOn(true, animated:true)
            
            //let firebase know that user agreed
            userDB.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: true)
            //print(userDB.Get_User_Data())
        }
        else
        {
            //set the switch to "off"
            cloudSW.setOn(false, animated: true)
            
            //let firebase know that user did not allow
            userDB.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: false)
            
            //print(userDB.Get_User_Data())
        }
    }
    
    @IBAction func doubleCheckDeleteRequest(_ sender: UIButton)
    {
        /* adapted source from: stackoverflow.com/questions/31101958/swift-ios-how-to-use-uibutton-to-trigger-uialertcontroller?rq=1*/
        let alert = UIAlertController(title: "Confirm Data Deletion", message: "Are you sure that you want to delete your data?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in self.requestDelete()}))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {action in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestDelete(){
        //call the DB function that clears user info
        userDB.Delete_userInfo()
        //call the DB function that clears the step data
        userDB.Clear_StepCount_Database()
        //call the DB function that clears the exercises done
        userDB.Clear_UserExerciseData_Database()
        //Clear the use info in the document
        global_UserDataFirestore.Clear_UserInfo(targetUser: nil) { returnVal in
            if( returnVal == 0 ) {
                global_UserData.Update_LastBackup(UserInfo: Date(), Routines: nil, Exercise: nil)
            }
        }
        //Clear the exercise data
        global_UserDataFirestore.Clear_ExerciseData(targetUser: nil) { returnVal in
            if( returnVal == 0 ) {
                global_UserData.Update_LastBackup(UserInfo: nil, Routines: nil, Exercise: Date())
            }
        }
        
        //test to see if UserInfo got deleted
        print("Check User DB: \(userDB.Get_User_Data())")
        print("Check Exercises Done DB: \(userDB.Get_Exercises_all())")
        
    }
}
