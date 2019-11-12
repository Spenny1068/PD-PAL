//
//  WalkingQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >
//<Oct. 28, 2019, Izyl Canonicato, Navigation to Routines (Home page)>
//<Nov. 1, 2019, Izyl Canonicato, Slider functionality)>
//<Nov. 2, 2019, Izyl Canonicato, Update/Insert WalkingDuration in UserData>

import UIKit

class WalkingQuestionViewController: UIViewController {
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    //Buttons
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Labels
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var walkingVal: UILabel!
    var walkingDurationVal = 0
    
    //Slider
    @IBAction func sliderChanged(_ sender: UISlider) {
        walkingVal.text = String(Int(sender.value)) + " mins"
        walkingDurationVal = Int(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Question
        QuestionLabel.text = "How long would you like your walking exercises to be?"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        //Slider
        walkingVal.text = "0 mins"
        walkingVal.textAlignment = .center
        walkingVal.applyQlabels()
        
        //Navigation Buttons
        completeButton.applyNextQButton()
        backButton.applyPrevQButton()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "EquipmentQuestionPage") as? EquipmentQuestionnaireViewController else{
            print("Couldn't find the view controller")
            return
        }
        present(destinationViewController, animated: true, completion: nil)
    }
    
    @IBAction func completeTapped(_ sender: UIButton) {
        //Update user's preferred walking duration
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: walkingDurationVal, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
        print(global_UserData.Get_User_Data())
    }
}
