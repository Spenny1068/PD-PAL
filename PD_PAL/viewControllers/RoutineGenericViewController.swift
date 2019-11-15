//
//  RoutineGenericViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-25.
//  Copyright © 2019 WareOne. All rights reserved.
//
//Revision History:
// <Date, Name, Changes made>
// <October 25 2019, Arian Vafadar, Designed Routine and Subroutine page>
//

import UIKit

class RoutineGenericViewController: UIViewController {
    
    @IBOutlet var Exercise1: UIButton!
    @IBOutlet var Exercise2: UIButton!
    @IBOutlet var Exercise3: UIButton!
    @IBOutlet var testVariable: UILabel!
    
    var routineNameFinal = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* if this page was instantiated through routines */
        if let vcc = segue.destination as? WallPushUpViewController { Global.IsRoutineExercise = 1 }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // remove back button
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue1                      // nav bar color
        self.title = nil                                                                                            // no page title in navigation bar
        
        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        var routineData = global_UserData.Get_Routine(NameOfRoutine: "Happy Day Workout")
    
        
        
        Exercise1.applyDesign()
        Exercise1.setTitle(routineData[0], for: .normal)
        Exercise2.applyDesign()
        Exercise2.setTitle(routineData[1], for: .normal)
        Exercise3.applyDesign()
        Exercise3.setTitle(routineData[2], for: .normal)
        
        testVariable.text = "Hi " + routineNameFinal
    }
    
    
    // called when home button on navigation bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}



