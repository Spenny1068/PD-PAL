//
//  SetUpViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels and buttons>
//<Oct. 28, 2019, Izyl Canonicato, navigation to Routines (Home page)>
//<Nov. 2, 2019, Izyl Canonicato, Insert/Update UserName into UserData>

import UIKit

class SetUpViewController: UIViewController {
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var SetUpButton: UIButton!
    @IBOutlet weak var SkipSetUpButton: UIButton!
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Question Label
        QuestionLabel.text = "Would you like to set-up your preferences now?"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        //Navigation Buttons
        SetUpButton.applyNextQButton()
        SkipSetUpButton.applyPrevQButton()
        SkipSetUpButton.setTitle("Later", for: .normal)
    }
    
    @IBAction func SetUpTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "IntenseQuestionPage") as? IntenseQuestionViewController else{
            print("Couldn't find the view controller")
            return
        }
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        print("Update: QuestionsAnswered")
        print(global_UserData.Get_User_Data())
      
        present(destinationViewController, animated: true, completion: nil)
    }
}
