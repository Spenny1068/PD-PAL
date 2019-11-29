//
//  CardioViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//

// REVISION HISTORY:
// <Date, Name, Changes made>
// <Oct. 26, 2019, Spencer Lall, added exercise buttons
// <November 27, 2019, Arian Vafadar, Highlighted the exercises>


import UIKit

class CardioViewController: UIViewController {

    /* IBOutlet Buttons */
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var exerciseButton2: UIButton!
    @IBOutlet weak var exerciseButton3: UIButton!
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [exerciseButton, exerciseButton2, exerciseButton3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* set IsRoutineExercise flag to 0 to signify we came from categories page */
        if let vcc = segue.destination as? ExerciseViewController { Global.IsRoutineExercise = 0 }
        
        /* use segue to forward pass exercise name to destination exercise view controller */
        if segue.identifier == "CardioSegue" {
            let vc = segue.destination as! ExerciseViewController
            vc.exercise_name = (sender as! UIButton).titleLabel!.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor
        logNavigationStack()
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIButton(type: .custom)
        homeButton.applyHomeButton()
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.rightBarButtonItem  = barButton

        /* page message */
        self.show_page_message(s1: "Cardio Exercises!", s2: "Cardio")
        
        let exercise_list = global_ExerciseData.exercise_names()
        
        //Use this to hightlight an exercise
        let exerciseRecommend = global_UserRecommendation.checkUserAns()
        
        /* exercise buttons */
        
        // button 1
        exerciseButton.setTitle(exercise_list[1],for: .normal)                        // button text
        exerciseButton.exerciseButtonDesign()
        exerciseButton.backgroundColor = Global.color_schemes.m_blue4          // background color
       //Highlights a Exercise if needed
        if (exerciseRecommend[1] == exercise_list[1])
        {
            exerciseButton.shadowButtonDesign()
        }

        // button 2
        //exerciseButton2.setTitle("EXERCISE 2",for: .normal)                        // button text
        exerciseButton2.setTitle(exercise_list[15],for: .normal)                        
        exerciseButton2.exerciseButtonDesign()
        exerciseButton2.backgroundColor = Global.color_schemes.m_blue4          // background color
        //Highlights a Exercise if needed
        if (exerciseRecommend[1] == exercise_list[15])
        {
            exerciseButton2.shadowButtonDesign()
        }

        // button 3
        exerciseButton3.setTitle(exercise_list[16],for: .normal)                        // button text
        exerciseButton3.exerciseButtonDesign()
        exerciseButton3.backgroundColor = Global.color_schemes.m_blue4          // background color
        //Highlights a Exercise if needed
        if (exerciseRecommend[1] == exercise_list[16])
        {
            exerciseButton3.shadowButtonDesign()
        }

        /* exercise buttons constraints */
        applyExerciseButtonConstraint(button: exerciseButton)
        applyExerciseButtonConstraint(button: exerciseButton2)
        applyExerciseButtonConstraint(button: exerciseButton3)
        
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
