//
//  FlexibilityViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>

import UIKit

class FlexibilityViewController: UIViewController {
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var exerciseButton2: UIButton!
    @IBOutlet weak var exerciseButton3: UIButton!
    @IBOutlet weak var exerciseButton4: UIButton!
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [exerciseButton, exerciseButton2, exerciseButton3, exerciseButton4])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* navigation bar stuff */
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_flexButton     // nav bar color
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil    // no page title in navigation bar

        // message
        self.show_page_message(s1: "Flexiblity Exercises!", s2: "Flexiblity")
        
        /* exercise buttons */
        
        // button 1
        exerciseButton.setTitle("SINGLE LEG STANCE",for: .normal)                        // button text
        exerciseButton.exerciseButtonDesign()
        exerciseButton.backgroundColor = Global.color_schemes.m_flexButton          // background color

        // button 2
        exerciseButton2.setTitle("EXERCISE 2",for: .normal)                        // button text
        exerciseButton2.exerciseButtonDesign()
        exerciseButton2.backgroundColor = Global.color_schemes.m_flexButton          // background color

        // button 3
        exerciseButton3.setTitle("EXERCISE 3",for: .normal)                        // button text
        exerciseButton3.exerciseButtonDesign()
        exerciseButton3.backgroundColor = Global.color_schemes.m_flexButton          // background color
        
        // button 4
        exerciseButton4.setTitle("EXERCISE 4",for: .normal)                        // button text
        exerciseButton4.exerciseButtonDesign()
        exerciseButton4.backgroundColor = Global.color_schemes.m_flexButton          // background color
        

        /* exercise buttons constraints */
        applyExerciseButtonConstraint(button: exerciseButton)
        applyExerciseButtonConstraint(button: exerciseButton2)
        applyExerciseButtonConstraint(button: exerciseButton3)
        applyExerciseButtonConstraint(button: exerciseButton4)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
