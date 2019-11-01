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

import UIKit

class WalkingQuestionViewController: UIViewController {
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    //Buttons
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Labels
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var walkingVal: UILabel!
    
    //Slider
    @IBAction func sliderChanged(_ sender: UISlider) {
        walkingVal.text = String(Int(sender.value)) + " mins"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Question
        QuestionLabel.text = "How long would you like your walking exercises to be?"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        //Slider
        walkingVal.text = "15 mins"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
