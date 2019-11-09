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
    @IBOutlet weak var E1: UIButton!
    @IBOutlet weak var E2: UIButton!
    @IBOutlet weak var E3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor
        
        //home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        // message
        self.present_message(s1: "Select A Routine To Try!", s2: "Routine")

        // routine buttons
        E1.setTitle("Happy Day Workout", for: .normal)
        E1.applyDesign()
        
        E2.setTitle("Friday Night Chill", for: .normal)
        E2.applyDesign()
        
        E3.setTitle("Monday Morning Mood", for: .normal)
        E3.applyDesign()
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

    @objc func buttonAction(sender: UIButton!) {
        print("button tapped")
    }
}




