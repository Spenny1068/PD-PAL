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
    
    @IBAction func nextTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "WalkingQuestionPage") as? WalkingQuestionViewController else{
            print("Couldn't find the view controller")
            return
        }
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
