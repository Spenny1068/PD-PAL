//
//  StrengthViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>
import UIKit

class StrengthViewController: UIViewController {
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var exerciseButton2: UIButton!
    @IBOutlet weak var exerciseButton3: UIButton!
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [exerciseButton, exerciseButton2, exerciseButton3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
    
    @IBOutlet weak var WallPushUpButton: UIButton!
    
    /* If this page was instantiated through categories */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcc = segue.destination as? WallPushUpViewController { Global.IsRoutineExercise = 0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // remove back button
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue1                      // nav bar color
        self.title = nil                                                                                            // no page title in navigation bar


        // message
        self.show_page_message(s1: "Strength Exercises!", s2: "Strength")
        
        /* exercise buttons */
        
        // button 1
        exerciseButton.setTitle("WALL PUSHUP",for: .normal)                        // button text
        exerciseButton.exerciseButtonDesign()
        exerciseButton.backgroundColor = Global.color_schemes.m_blue2          // background color

        // button 2
        exerciseButton2.setTitle("EXERCISE 2",for: .normal)                        // button text
        exerciseButton2.exerciseButtonDesign()
        exerciseButton2.backgroundColor = Global.color_schemes.m_blue2          // background color

        // button 3
        exerciseButton3.setTitle("EXERCISE 3",for: .normal)                        // button text
        exerciseButton3.exerciseButtonDesign()
        exerciseButton3.backgroundColor = Global.color_schemes.m_blue2          // background color
        
        /* exercise buttons constraints */
        applyExerciseButtonConstraint(button: exerciseButton)
        applyExerciseButtonConstraint(button: exerciseButton2)
        applyExerciseButtonConstraint(button: exerciseButton3)
        
        self.view.addSubview(stackView)
        applyStackViewConstraints(SV: stackView)

        
        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
    }
    
    
    // called when home button on navigation bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}
