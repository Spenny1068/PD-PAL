//
//  WalkingViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class WalkingViewController: UIViewController {

    // IBOutlet buttons and labels
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var viewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        self.show_page_message(s1: "WALKING", s2: "WALKING")
        image.image = UIImage(named: "Walking.png")

        // read exercise info into labels
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: "WALKING")
        
        // exercise description and duration text
        self.show_exercise_description(string: readResult.Description)
        self.show_exercise_duration(string: readResult.Duration)
        
        // view button
        viewButton.viewButtonDesign()
        applyViewButtonConstraints(button: viewButton)
        
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
    
    @objc func selectButtonTapped(sender: UIButton!) {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        // insert excercise as done
        global_UserData.Add_Exercise_Done(ExerciseName: "WALKING", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
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
