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

import UIKit

class SettingsViewController: UIViewController {
    
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)

    @IBOutlet weak var cloudSW: UISwitch!
    let userDB = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* page message */
        self.show_page_message(s1: "Change Your Settings!", s2: "Settings")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
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
}
