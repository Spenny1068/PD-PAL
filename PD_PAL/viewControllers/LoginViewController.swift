//
//  LoginViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, Error handling>

import Foundation
import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ValidationMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ValidationMessage.isHidden = true
        userNameTextField.delegate = self
        let title = UILabel()
        title.text = "Welcome to PD PAL!"
        title.applyQuestionDesign()
        //myButton.titleLabel?.font =  UIFont(name: YourfontName, size: 20)
        LoginButton.applyInputButton()
        LoginButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 20)
        self.view.addSubview(title)
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        //let userName = userNameTextField.text
        ValidationMessage.isHidden = true
        guard let userName = userNameTextField.text, (userNameTextField.text?.count != 0), !(isValidName(name: userNameTextField.text!)) else {
            ValidationMessage.text = "Please enter a valid name"
            ValidationMessage.applyErrorDesign()
            ValidationMessage.isHidden = false
            return
        }
        
        //Store username here
        navigateToQuestionnaire()
        
    }
    
    //Give access to Questionnaire Storyboard
    private func navigateToQuestionnaire(){
        let mainStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
        guard let quesNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "SetUpQuestionPage") as? SetUpViewController else {
            return
        }
        
        //modular 
        present(quesNavigationVC, animated: true ,completion: nil)
    }
    
    //Check if name contains only letter and white spaces
    func isValidName(name:String)->Bool{
        let regex = "[^A-Za-z]+"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return nameTest.evaluate(with: name)
    }
    
}

//closes keyboard
extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true;
    }
}
