//
//  LoginViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        navigateToQuestionnaire()
    }
    
    private func navigateToQuestionnaire(){
        //give access to Questionnaire Storyboard
        let mainStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)
        guard let quesNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "QuestionnaireNavController") as? QuestionnaireNavController else {
            return
        }
        
        //modular 
        present(quesNavigationVC, animated: true ,completion: nil)
    }
}
