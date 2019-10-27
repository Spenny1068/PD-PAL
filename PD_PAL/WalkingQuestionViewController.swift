//
//  WalkingQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >

import UIKit

class WalkingQuestionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //Question
        let frameLabel:CGRect = CGRect(x: screenWidth/2-150, y:screenHeight/2-150, width: 300, height: 150)
        let question = UILabel(frame: frameLabel)
        question.text = "How long would you like your walking exercise to be?"
        question.numberOfLines = 3
        question.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        question.textAlignment = .center
        self.view.addSubview(question)
        
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
