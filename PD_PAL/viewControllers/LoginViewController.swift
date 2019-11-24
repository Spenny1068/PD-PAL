//
//  LoginViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, Error handling>
//<Nov. 2, 2019, Izyl Canonicato, Insert/Update questionsAnswered into UserData>
//<Nov. 23, 2019, Izyl Canonicato, Updated IB constraints>

import Foundation
import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ValidationMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.fullScreen();
        //Load error and title label
        ValidationMessage.isHidden = true
        userNameTextField.delegate = self
        TitleLabel.text = "Welcome to PD PAL!"
        TitleLabel.textColor = Global.color_schemes.m_blue1
        TitleLabel.applyTitle()
        LoginButton.applyInputButton()
        LoginButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 20)
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        ValidationMessage.isHidden = true
        guard let userName = userNameTextField.text, (userNameTextField.text?.count != 0), !(isValidName(name: userNameTextField.text!)) else {
            ValidationMessage.text = "Please enter a valid name"
            ValidationMessage.applyErrorDesign()
            ValidationMessage.isHidden = false
            return
        }
        
        // Store username to DB
        if(userNameTextField.text?.count != 0){
            global_UserData.Update_User_Data(nameGiven: userName, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
            print("Update Username")
            print(global_UserData.Get_User_Data())
        }
        //navigateToQuestionnaire()
    }
    
    // Give access to Questionnaire Storyboard
//    private func navigateToQuestionnaire(){
//        let mainStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
//        guard let quesNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "SetUpQuestionPage") as? SetUpViewController else {
//            return
//        }
        
    // Navigation to Set up page
//        show(quesNavigationVC, sender: LoginViewController.self)
   // }
    
    // Check if name contains only letter and white spaces
    func isValidName(name:String)->Bool{
        let regex = "[^A-Za-z]+"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return nameTest.evaluate(with: name)
    }
    
}

// Closes keyboard when 'return' is tapped 
extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true;
    }
}
