//
//  SetUpViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >

import UIKit

class SetUpViewController: UIViewController {

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
