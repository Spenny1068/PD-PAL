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
    @IBOutlet weak var QuestionLabel: UILabel!
    var button_clicked = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Question
        //let question = UILabel()
        QuestionLabel.text = "How intense would you like your exercise to be?"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        lightIntensity.applyQButton()
        modIntensity.applyQButton()
        intenseIntensity.applyQButton()
        nextButton.applyNextQButton()
        nextButton.isEnabled = false
    }
    
    @IBAction func lightSelected(_ sender: UIButton) {
        button_clicked = true
        nextButton.isEnabled = true
    }
    
    @IBAction func moderateSelected(_ sender: UIButton) {
        button_clicked = true
        nextButton.isEnabled = true
    }
    
    @IBAction func intenseSelected(_ sender: UIButton) {
        button_clicked = true
        nextButton.isEnabled = true
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "EquipmentQuestionPage") as? EquipmentQuestionnaireViewController else{
            print("Couldn't find the view controller")
            return
        }
        present(destinationViewController, animated: true, completion: nil)
        //else prompt message
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
