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
    
//    lazy var stackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [exerciseButton, exerciseButton2, exerciseButton3])    // elements in stackview
//        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
//        sv.axis = .vertical                                     // stackview orientation
//        sv.spacing = 50                                         // spacing between elements
//        sv.distribution = .fillEqually
//        return sv
//    }()
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor  // ackground color

        // message
        self.present_message(s1: "Select An Exercise!", s2: "Exercise")
        

        /* exercise buttons */
        
        // button 1
        exerciseButton.setTitle("SINGLE LEG STANCE",for: .normal)                        // button text
        exerciseButton.exerciseButtonDesign()
        exerciseButton.backgroundColor = Global.color_schemes.m_blue3          // background color

        // button 2
        exerciseButton2.setTitle("EXERCISE 2",for: .normal)                        // button text
        exerciseButton2.exerciseButtonDesign()
        exerciseButton2.backgroundColor = Global.color_schemes.m_blue2          // background color

        // button 3
        exerciseButton3.setTitle("EXERCISE 3",for: .normal)                        // button text
        exerciseButton3.exerciseButtonDesign()
        exerciseButton3.backgroundColor = Global.color_schemes.m_blue1          // background color
        
        // show buttons
        self.view.addSubview(exerciseButton)
        self.view.addSubview(exerciseButton2)
        self.view.addSubview(exerciseButton3)

        
        /* exercise buttons constraints */
        
        // exercise button 1
        NSLayoutConstraint.activate([
            exerciseButton.widthAnchor.constraint(equalToConstant: 304),
            exerciseButton.heightAnchor.constraint(equalToConstant: 81),
            exerciseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            exerciseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            exerciseButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 187)
        ])
        
        // exercise button 2
        NSLayoutConstraint.activate([
            exerciseButton2.widthAnchor.constraint(equalToConstant: 304),
            exerciseButton2.heightAnchor.constraint(equalToConstant: 81),
            exerciseButton2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            exerciseButton2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            exerciseButton2.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 343)
        ])
        
        // exercise button 3
        NSLayoutConstraint.activate([
            exerciseButton3.widthAnchor.constraint(equalToConstant: 304),
            exerciseButton3.heightAnchor.constraint(equalToConstant: 81),
            exerciseButton3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            exerciseButton3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            exerciseButton3.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 497)
        ])
        
//        self.view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25),
//            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25),
//            //stackView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
//            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
//            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
//        ])
        

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
