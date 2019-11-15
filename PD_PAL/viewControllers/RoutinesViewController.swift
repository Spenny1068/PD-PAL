//
//  RoutinesViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 25 2019, Arian Vafadar, Designed Routine and Subroutine page>
// <October 26, 2019, Arian Vafadar, added pictures and updated Main routine page>
// <October 27, 2019, Spencer Lall, applied default page design>

import UIKit

class RoutinesViewController: UIViewController {
    
    // IBOutlet buttons
    @IBOutlet weak var routineButton1: UIButton!
    @IBOutlet weak var routineButton2: UIButton!
    @IBOutlet weak var routineButton3: UIButton!
    
    var routineName = ""
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [routineButton1, routineButton2, routineButton3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
    
    var routineNames = global_UserData.Get_Routines()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.color_schemes.m_bgColor
        
        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        // message
        self.show_page_message(s1: "Select A Routine To Try!", s2: "Routine")
        
        //var routineNames = global_UserData.Get_Routines()

        // apply designs to routine buttons
        routineButton1.setTitle(routineNames[0].0, for: .normal)    // access routine name in tuple
        routineButton1.routineButtonDesign()
        
        routineButton2.setTitle(routineNames[1].0, for: .normal)
        routineButton2.routineButtonDesign()
        
        routineButton3.setTitle(routineNames[2].0, for: .normal)
        routineButton3.routineButtonDesign()
        
        /* routine button constraints */
        applyExerciseButtonConstraint(button: routineButton1)
        applyExerciseButtonConstraint(button: routineButton2)
        applyExerciseButtonConstraint(button: routineButton3)
        
        self.view.addSubview(stackView)
        applyStackViewConstraints(SV: stackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
    //Action for the Routine buttons
        @IBAction func routineButtonAction1(_ sender: Any) {
            self.routineName = routineNames[0].0 
            performSegue(withIdentifier: "routine1", sender: self)
        }
    
        @IBAction func routineButtonAction2(_ sender: Any) {
            self.routineName = routineNames[1].0 
            performSegue(withIdentifier: "routine2", sender: self)
        }
    
        @IBAction func routineButtonAction3(_ sender: Any) {
            self.routineName = routineNames[2].0
            performSegue(withIdentifier: "routine3", sender: self)
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            var vc = segue.destination as! RoutineGenericViewController
            vc.routineNameFinal = self.routineName
        }
    
   // called when home button on navigation bar is tapped
   @objc func homeButtonTapped(sender: UIButton!) {
       let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
       self.present(newViewController, animated: true, completion: nil)
   }
}




