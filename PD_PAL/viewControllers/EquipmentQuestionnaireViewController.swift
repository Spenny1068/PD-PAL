//
//  EquipmentQuestionnaireViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels and buttons>
//<Nov. 2, 2019, Izyl Canonicato, Insert/Update Equipment available into UserData>


import UIKit

class EquipmentQuestionnaireViewController: UIViewController {
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    
    //Buttons
    @IBOutlet weak var RBandCheckbox:UIButton!
    @IBOutlet weak var chairCheckbox:UIButton!
    @IBOutlet weak var weightsCheckbox:UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Labels
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var resistiveBandLabel: UILabel!
    @IBOutlet weak var chairLabel: UILabel!
    @IBOutlet weak var weightsLabel: UILabel!
    var counter1 = 0
    var counter2 = 0
    var counter3 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Question
        QuestionLabel.text = "Do you have access to a:"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        // Instruction msg
        InstructionLabel.text = "(Check any that you have)"
        InstructionLabel.textAlignment = .center
        InstructionLabel.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        
        // Labels
        resistiveBandLabel.text = "Resistive Band"
        resistiveBandLabel.applyQlabels()
        chairLabel.text = "Chair"
        chairLabel.applyQlabels()
        weightsLabel.text = "Weights"
        weightsLabel.applyQlabels()
        
        // Navigation Buttons
        nextButton.applyNextQButton()
        backButton.applyPrevQButton()
        
    }
    
    @IBAction func resistiveBandTapped(_ sender: UIButton) {
        counter1 += 1
        if(counter1 == 2){counter1 = 0}
        if(counter1 == 1){
             global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: true, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        } else if(counter1 == 0){
             global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: false, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        }
        print("RB")
        print(global_UserData.Get_User_Data())
    }
    
    @IBAction func chairTapped(_ sender: UIButton) {
        counter2 += 1
        if(counter2 == 2){counter2 = 0}
        if(counter2 == 1){
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: true, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        } else if(counter2 == 0){
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: false, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        }
    }
    
    @IBAction func weightsTapped(_ sender: UIButton) {
        counter3 += 1
        if(counter3 == 2){counter3 = 0}
        if(counter3 == 1){
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: true, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        } else if(counter3 == 0){
            global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: false, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        }
    }
    
    @IBAction func checkMarkTapped(sender: UIButton){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations:{
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){(success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }

    // Navigation to previous VC
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.backToViewController(vc: IntenseQuestionViewController.self)
    }
}
