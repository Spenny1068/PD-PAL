//
//  IntenseQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >

import UIKit

class IntenseQuestionViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lightIntensity: UIButton!
    @IBOutlet weak var modIntensity: UIButton!
    @IBOutlet weak var intenseIntensity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //Question
        let question = UILabel()
        question.text = "How intense would you like your exercise to be?"
        question.applyQuestionDesign()
        self.view.addSubview(question)
        
//        nextButton.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 + 150, width: 100, height: 150)
        lightIntensity.applyDesign()
        modIntensity.applyDesign()
        intenseIntensity.applyDesign()
        nextButton.applyNextQButton()
        self.view.addSubview(nextButton)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
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
