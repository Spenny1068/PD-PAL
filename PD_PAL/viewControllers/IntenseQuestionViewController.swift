//
//  IntenseQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels>
//<Nov. 2, 2019, Izyl Canonicato, Insert/Update Intensity into UserData>

import UIKit

class IntenseQuestionViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lightIntensity: UIButton!
    @IBOutlet weak var modIntensity: UIButton!
    @IBOutlet weak var intenseIntensity: UIButton!
    @IBOutlet weak var QuestionLabel: UILabel!
    var button_clicked = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Question Label
        QuestionLabel.text = "How intense would you like your exercise to be?"
        QuestionLabel.applyQuestionDesign()
        
        // Button styling
        lightIntensity.applyQButton()
        modIntensity.applyQButton()
        intenseIntensity.applyQButton()
        nextButton.applyNextQButton()
        nextButton.isEnabled = false
        nextButton.backgroundColor = Global.color_schemes.m_blue1
        
        // Update User intensity parameter in DB
        if(button_clicked.count != 0){
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: button_clicked, pushNotificationsDesired: nil, firestoreOK: nil)
            nextButton.applyNextQButton()
            print("Update Intensity")
            print(global_UserData.Get_User_Data())
        }
    }
    
    // checking navigation stack
    override func viewDidAppear(_ animated: Bool) {
        var viewC = self.navigationController?.viewControllers
        print("Log: VC from Intense", viewC)
    }
    
    @IBAction func lightSelected(_ sender: UIButton) {
        button_clicked = "Light"
        nextButton.isEnabled = true
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil,       resistBandAvailable: nil, poolAvailable: nil, intensityDesired: button_clicked, pushNotificationsDesired: nil, firestoreOK: nil)
    }
    
    @IBAction func moderateSelected(_ sender: UIButton) {
        button_clicked = "Moderate"
        nextButton.isEnabled = true
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: button_clicked, pushNotificationsDesired: nil, firestoreOK: nil)
    }
    
    @IBAction func intenseSelected(_ sender: UIButton) {
        button_clicked = "Intense"
        nextButton.isEnabled = true
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: button_clicked, pushNotificationsDesired: nil, firestoreOK: nil)
    }
}
