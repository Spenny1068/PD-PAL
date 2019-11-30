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
//<Nov. 29, 2019, William Huong, Added check for unique names>

import Foundation
import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ValidationMessage: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.fullScreen();
        //Load error and title label
        ValidationMessage.isHidden = true
        ValidationMessage.applyErrorDesign()
        userNameTextField.delegate = self
        TitleLabel.text = "Welcome to PD PAL!"
        TitleLabel.textColor = Global.color_schemes.m_blue1
        TitleLabel.applyTitle()
        LoginButton.applyInputButton()
        userNameLabel.applyQuestionDesign()
        userNameLabel.text = "Username"
        userNameLabel.textAlignment = .left
      
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        ValidationMessage.isHidden = true
        var validName = isValidName(name: userNameTextField.text!)
        guard let userName = userNameTextField.text, (userNameTextField.text?.count != 0), !(validName) else {
            self.ValidationMessage.text = "Username is not valid"
            self.ValidationMessage.isHidden = false
            return
        }
        
        global_UserDataFirestore.Name_Available(nameToCheck: userName) { returnVal in
        
            if( returnVal != true ) {
                self.ValidationMessage.text = "Username has already been taken"
                self.ValidationMessage.isHidden = false
                return
            }
            
            // Store username to DB
            if(self.userNameTextField.text?.count != 0){
                global_UserData.Update_User_Data(nameGiven: userName, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
                print("Update Username")
                print(global_UserData.Get_User_Data())
            }
        
            // Segue to Set up Question page
            if !validName {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Questionnare", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpQuestionPage")
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            
        }
        
    }
    
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
