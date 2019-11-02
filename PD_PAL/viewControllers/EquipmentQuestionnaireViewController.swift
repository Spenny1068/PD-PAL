//
//  EquipmentQuestionnaireViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels and buttons>

import UIKit

class EquipmentQuestionnaireViewController: UIViewController {
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    
    //Buttons
    @IBOutlet weak var RBandCheckbox:UIButton!
    @IBOutlet weak var chairCheckbox:UIButton!
    @IBOutlet weak var weightsCheckbox:UIButton!
    @IBOutlet weak var poolCheckbox:UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Labels
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var resistiveBandLabel: UILabel!
    @IBOutlet weak var chairLabel: UILabel!
    @IBOutlet weak var weightsLabel: UILabel!
    @IBOutlet weak var poolLabel: UILabel!
    var counter1 = 0
    var counter2 = 0
    var counter3 = 0
    var counter4 = 0
    var value1 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Question
        QuestionLabel.text = "Do you have access to a(n):"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        //Instruction msg
        InstructionLabel.text = "(Check any that you have)"
        InstructionLabel.textAlignment = .center
        InstructionLabel.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        
        //Labels
        resistiveBandLabel.text = "Resistive Band"
        resistiveBandLabel.applyQlabels()
        chairLabel.text = "Chair"
        chairLabel.applyQlabels()
        weightsLabel.text = "Weights"
        weightsLabel.applyQlabels()
        poolLabel.text = "Pool"
        poolLabel.applyQlabels()
        
        //Navigation Buttons
        nextButton.applyNextQButton()
        backButton.applyPrevQButton()
        
    }
    
    @IBAction func resistiveBandTapped(_ sender: UIButton) {
        counter1 += 1
        if(counter1 == 1){value1 = false}
        if(counter1 == 2){counter1 = 0}
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: value1, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
    }
    
    @IBAction func chairTapped(_ sender: UIButton) {
        counter2 += 1
        if(counter2 == 1){value1 = false}
        if(counter2 == 2){counter1 = 0}
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: value1, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
    }
    
    @IBAction func weightsTapped(_ sender: UIButton) {
        counter3 += 1
        if(counter3 == 1){value1 = false}
        if(counter3 == 2){counter1 = 0}
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: value1, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
    }
    
    @IBAction func poolTapped(_ sender: UIButton) {
        counter4 += 1
        if(counter4 == 1){value1 = false}
        if(counter4 == 2){counter1 = 0}
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: value1, intensityDesired: nil, pushNotificationsDesired: nil)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "WalkingQuestionPage") as? WalkingQuestionViewController else{
            print("Couldn't find the view controller")
            return
        }
        print("equipment")
        print(global_UserData.Get_User_Data())
        present(destinationViewController, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "IntenseQuestionPage") as? IntenseQuestionViewController else{
            print("Couldn't find the view controller")
            return
        }
        present(destinationViewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
