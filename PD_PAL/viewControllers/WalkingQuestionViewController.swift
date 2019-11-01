//
//  WalkingQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >
//<Oct. 28, 2019, Izyl Canonicato, Navigation to Routines (Home page)>

import UIKit

class WalkingQuestionViewController: UIViewController {
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //Question
        let question = UILabel()
        question.text = "How long would you like your walking exercise to be?"
        question.applyQuestionDesign()
        self.view.addSubview(question)
        
        //Navigation Buttons
//        completeButton.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 + 150, width: 100, height: 150)
//        backButton.frame = CGRect(x: screenWidth/2 - 150, y: screenHeight/2 + 150, width: 100, height: 150)
        completeButton.applyNextQButton()
        self.view.addSubview(completeButton)
        
        backButton.applyPrevQButton()
        self.view.addSubview(backButton)
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
