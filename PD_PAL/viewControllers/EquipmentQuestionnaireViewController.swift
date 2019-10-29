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
    @IBOutlet weak var RBandCheckbox:UIButton!
    @IBOutlet weak var chairCheckbox:UIButton!
    @IBOutlet weak var weightsCheckbox:UIButton!
    @IBOutlet weak var poolCheckbox:UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //Question
        let question = UILabel()
        question.text = "Do you have access to a(n):"
        question.applyQuestionDesign()
        self.view.addSubview(question)
        
        //Instruction msg
        let frameLabel2:CGRect = CGRect(x: screenWidth/2-150, y: screenHeight/2 - 100, width: 300, height: 150)
        let msg = UILabel(frame: frameLabel2)
        msg.text = "(Check any that you have)"
        msg.numberOfLines = 1
        msg.textAlignment = .center
        msg.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        self.view.addSubview(msg)
        
        RBandCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .normal)
        RBandCheckbox.setImage(UIImage(named:"Checkmarks"), for: .selected)
        chairCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .normal)
        chairCheckbox.setImage(UIImage(named:"Checkmarks"), for: .selected)
        weightsCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .normal)
        weightsCheckbox.setImage(UIImage(named:"Checkmarks"), for: .selected)
        poolCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .normal)
        poolCheckbox.setImage(UIImage(named:"Checkmarks"), for: .selected)
        
        
        //Navigation Buttons
        nextButton.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 + 150, width: 100, height: 150)
        backButton.frame = CGRect(x: screenWidth/2 - 150, y: screenHeight/2 + 150, width: 100, height: 150)
        
    }
    
    @IBAction func checkMarkTapped(sender: UIButton){
        UIView.animate(withDuration:0.2, delay: 0.1, options: .curveLinear, animations:{
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){(success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
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
