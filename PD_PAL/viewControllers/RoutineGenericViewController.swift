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
    
    /* IBOutlet Buttons */
    @IBOutlet weak var RoutineExercise1: UIButton!
    @IBOutlet weak var RoutineExercise2: UIButton!
    @IBOutlet weak var RoutineExercise3: UIButton!
    
    // global variables
    var routine_name: String!
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [RoutineExercise1, RoutineExercise2, RoutineExercise3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* set IsRoutineExercise flag to 1 to signify we came from routines page */
        if let vcc = segue.destination as? ExerciseViewController { Global.IsRoutineExercise = 1 }
        
        /* use segue to forward pass exercise name to destination exercise view controller */
        if segue.identifier == "RoutineSegue" {
            let vc = segue.destination as! ExerciseViewController
            vc.exercise_name = (sender as! UIButton).titleLabel!.text!
            Global.routine_data = global_UserData.Get_Routine(NameOfRoutine: routine_name)
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor
        let routineData = global_UserData.Get_Routine(NameOfRoutine: routine_name)
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        /* page message */
        self.show_page_message(s1: routine_name, s2: routine_name)
        
        /* routine exercise buttons */
        
        //-> button 1
        RoutineExercise1.setTitle(routineData[0],for: .normal)                        // button text
        RoutineExercise1.exerciseButtonDesign()
        RoutineExercise1.backgroundColor = Global.color_schemes.m_blue1          // background color

        //-> button 2
        RoutineExercise2.setTitle(routineData[1],for: .normal)                        // button text
        RoutineExercise2.exerciseButtonDesign()
        RoutineExercise2.backgroundColor = Global.color_schemes.m_blue1          // background color

        //-> button 3
        RoutineExercise3.setTitle(routineData[2],for: .normal)                        // button text
        RoutineExercise3.exerciseButtonDesign()
        RoutineExercise3.backgroundColor = Global.color_schemes.m_blue1          // background color
        
        /* exercise buttons constraints */
        applyExerciseButtonConstraint(button: RoutineExercise1)
        applyExerciseButtonConstraint(button: RoutineExercise2)
        applyExerciseButtonConstraint(button: RoutineExercise3)
        
        self.view.addSubview(stackView)
        applyStackViewConstraints(SV: stackView)
    }
    
    // called when home button on navigation bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}



