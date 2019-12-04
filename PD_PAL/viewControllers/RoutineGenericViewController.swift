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
// <November 1, 2019, Spencer Lall, Updated the default page design>
// <November 8, 2019, Spencer Lall, Changed the StoryBoard Layout for the Routines>
// <November 9, 2019, Spencer Lall, Put the buttons in the stackview>
// <November 10, 2019, Spencer Lall, passed information into the exercise viewcontroller>
// <November 11, 2019, Izyl Canonicato, Created the viewController button design>
// <November 27, 2019, Arian Vafadar, Highlighted the exercises>
// <November 28, 2019, Izyl Canonicato, Implemented the Timer>
//

import UIKit

class RoutineGenericViewController: UIViewController {
    
    /* IBOutlet Buttons */
    @IBOutlet weak var StartRoutineButton: UIButton!
    @IBOutlet weak var RoutineExercise1: UILabel!
    @IBOutlet weak var RoutineExercise2: UILabel!
    @IBOutlet weak var RoutineExercise3: UILabel!
    
    /* IBOulet labels */
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    // global variables
    var routine_name: String!

    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [RoutineExercise1, RoutineExercise2, RoutineExercise3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 0                                         // spacing between elements
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
            
            //let routine = (sender as! UIButton).titleLabel!.text!
            let routine_data = global_UserData.Get_Routine(NameOfRoutine: self.routine_name)
            vc.exercise_name = routine_data[0]
            Global.routine_data = global_UserData.Get_Routine(NameOfRoutine: routine_name)
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        logNavigationStack()
        
        view.backgroundColor = Global.color_schemes.m_bgColor
        let routineData = global_UserData.Get_Routine(NameOfRoutine: routine_name)
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIButton(type: .custom)
        homeButton.applyHomeButton()
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.rightBarButtonItem  = barButton
        
        /* page message */
        self.show_page_message(s1: routine_name, s2: routine_name)
        
        /* Description for Routines */
        let happyDayDescription = "This routine is intended to brighten up your day and improve your mood"
        let mondayMorningMoodDescription = "This routine will get your week started off right"
        let fridayNightChillDescription = "This routine will end a long week with a relaxing and soothing workout"
        
        if (routine_name == "Happy Day Workout") {
            self.show_routine_description(string:happyDayDescription, DLabel: DescriptionLabel, DText: DescriptionText)
        }
            
        else if (routine_name == "Monday Morning Mood") {
            self.show_routine_description(string:mondayMorningMoodDescription, DLabel: DescriptionLabel, DText: DescriptionText)
        }
            
        else if (routine_name == "Friday Night Chill") {
            self.show_routine_description(string:fridayNightChillDescription, DLabel: DescriptionLabel, DText: DescriptionText)
        }

        /* routine exercise labels */
        //-> label 1
        RoutineExercise1.text = "   1.) \(routineData[0])"
        RoutineExercise1.applyExerciseLabelDesign()
        //RoutineExercise1.backgroundColor = Global.color_schemes.m_blue1          // background color

        //-> label 2
        RoutineExercise2.text = "   2.) \(routineData[1])"
        RoutineExercise2.applyExerciseLabelDesign()
        //RoutineExercise2.backgroundColor = Global.color_schemes.m_blue1          // background color

        //-> label 3
        RoutineExercise3.text = "   3.) \(routineData[2])"
        RoutineExercise3.applyExerciseLabelDesign()
        //RoutineExercise3.backgroundColor = Global.color_schemes.m_blue1          // background color
        
        /* exercise buttons constraints */
        applyExerciseLabelConstraint(label: RoutineExercise1)
        applyExerciseLabelConstraint(label: RoutineExercise2)
        applyExerciseLabelConstraint(label: RoutineExercise3)
                
        /* button to start routine */
        StartRoutineButton.exerciseButtonDesign()
        StartRoutineButton.backgroundColor = Global.color_schemes.m_blue4
        StartRoutineButton.setTitle("Start Routine", for: .normal)
        self.view.addSubview(StartRoutineButton)
        NSLayoutConstraint.activate([
            StartRoutineButton.widthAnchor.constraint(equalToConstant: 304),
            StartRoutineButton.heightAnchor.constraint(equalToConstant: 81),
            StartRoutineButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            StartRoutineButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            StartRoutineButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 550)
        ])
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25),
            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -160)
        ])
    }
    
    // called when home button on navigation bar is tapped
//    @objc func homeButtonTapped(sender: UIButton!) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
//        self.present(newViewController, animated: true, completion: nil)
//    }
}



