//
//  WalkingQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class WalkingQuestionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Question
        let question = UILabel(frame: CGRect.zero)
        question.text = "How long would you like your walking exercise to be?"
        question.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        self.view.addSubview(question)
        
        
//        NSLayoutConstraint.activate([
//
//        ])
        // Do any additional setup after loading the view.
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
