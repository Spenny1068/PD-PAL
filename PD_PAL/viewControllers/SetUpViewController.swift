//
//  SetUpViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels and buttons>
//<Oct. 28, 2019, Izyl Canonicato, navigation to Routines (Home page)>

import UIKit

class SetUpViewController: UIViewController {
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var SetUpButton: UIButton!
    @IBOutlet weak var SkipSetUpButton: UIButton!
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Question
        QuestionLabel.text = "Would you like to set-up your preferences now?"
        QuestionLabel.applyQuestionDesign()
        self.view.addSubview(QuestionLabel)
        
        //Navigation Buttons
        SetUpButton.applyNextQButton()
        self.view.addSubview(SetUpButton)
        SkipSetUpButton.applyPrevQButton()
        self.view.addSubview(SkipSetUpButton)
        
    }
    
    @IBAction func SetUpTapped(_ sender: Any) {
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
