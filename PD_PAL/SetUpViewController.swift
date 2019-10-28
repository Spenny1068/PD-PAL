//
//  SetUpViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels and buttons>

import UIKit

class SetUpViewController: UIViewController {
    @IBOutlet weak var SetUpButton: UIButton!
    @IBOutlet weak var SkipSetUpButton: UIButton!
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //Question
        let frameLabel1:CGRect = CGRect(x: screenWidth/2-150, y:screenHeight/2 - 150, width: 300, height: 150)
        let question = UILabel(frame: frameLabel1)
        question.text = "Would you like to set-up your preferences now?"
        question.numberOfLines = 2
        question.lineBreakMode = .byWordWrapping
        question.textAlignment = .center
        question.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        self.view.addSubview(question)
        
        //Navigation Buttons
        SetUpButton.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 + 150, width: 100, height: 150)
        
        SkipSetUpButton.frame = CGRect(x: screenWidth/2 - 150, y: screenHeight/2 + 150, width: 100, height: 150)
        
    }
    
    @IBAction func SetUpTapped(_ sender: Any) {
        guard let destinationViewController = QuestionStoryboard.instantiateViewController(withIdentifier: "IntenseQuestionPage") as? IntenseQuestionViewController else{
            print("Couldn't find the view controller")
            return
        }
        
        present(destinationViewController, animated: true, completion: nil)
    }
    
//    @IBAction func SkipSetupTapped(_ sender: Any) {
//        guard let destinationViewController1 = QuestionStoryboard.instantiateViewController(withIdentifier: "mainPage") as? mainPageViewController else{
//            print("Couldn't find the view controller")
//            return
//        }
//
//        present(destinationViewController1, animated: true, completion: nil)
    
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
