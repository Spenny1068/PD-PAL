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
        
        deleteData.settingsButtonDesign()
        updateProfile.settingsButtonDesign()
        linkWebsiteBtn.settingsButtonDesign()
        cloudSW.isOn = global_UserData.Get_User_Data().FirestoreOK
        cloudSW.setOn(global_UserData.Get_User_Data().FirestoreOK, animated: true) //set initial switch status to false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
    override func viewWillAppear(_ animated: Bool){
        cloudSW.isOn = global_UserData.Get_User_Data().FirestoreOK
        cloudSW.setOn(cloudSW.isOn, animated: true)
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        if cloudSW.isOn{
            //set the switch to "on"
            cloudSW.setOn(true, animated:true)
            
            //let firebase know that user agreed
           global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: true)
            //print(userDB.Get_User_Data())
        }
        else
        {
            //set the switch to "off"
            cloudSW.setOn(false, animated: true)
            
            //let firebase know that user did not allow
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: false)
            
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
        global_UserData.Delete_userInfo()
        //call the DB function that clears the step data
        global_UserData.Clear_StepCount_Database()
        //call the DB function that clears the exercises done
        global_UserData.Clear_UserExerciseData_Database()
        //Clear the use info in the document
        global_UserDataFirestore.Clear_UserInfo(targetUser: nil) { returnVal in
            if( returnVal == 0 ) {
                global_UserData.Update_LastBackup(UserInfo: Date(), Exercise: nil)
            }
        }
        //Clear the exercise data
        global_UserDataFirestore.Clear_ExerciseData(targetUser: nil) { returnVal in
            if( returnVal == 0 ) {
                global_UserData.Update_LastBackup(UserInfo: nil, Exercise: Date())
            }
        }
        
        cloudSW.isOn = false
        
        //test to see if UserInfo got deleted
        print("Check User DB: \(global_UserData.Get_User_Data())")
        print("Check Exercises Done DB: \(global_UserData.Get_Exercises_all())")
        
    }
}
