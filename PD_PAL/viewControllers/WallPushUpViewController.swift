//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class WallPushUpViewController: UIViewController {
    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var DurationLabel: UILabel!
    @IBOutlet weak var SelectButton: UIButton!
    @IBOutlet var DescriptionText: UITextView!
    @IBOutlet var DurationText: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor

        
        // read exercise info into labels
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: "WALL PUSH-UP")
        DescriptionText.text = readResult.Description
        DurationText.text = readResult.Duration
        
        DescriptionLabel.DescriptionDurationDesign()
        DurationLabel.DescriptionDurationDesign()
        SelectButton.DesignSelect()
        
        // page name
        let pageName = UILabel(frame: CGRect.zero)
        pageName.text = "WALL PUSH-UP"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        NSLayoutConstraint.activate([
            pageName.widthAnchor.constraint(equalToConstant: 350),
            pageName.heightAnchor.constraint(equalToConstant: 50),
            pageName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            pageName.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75)
        ])
        
        // select button
        SelectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        SelectButton.contentHorizontalAlignment = .center
        NSLayoutConstraint.activate([
            SelectButton.widthAnchor.constraint(equalToConstant: 240),
            SelectButton.heightAnchor.constraint(equalToConstant: 50),
            SelectButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            SelectButton.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 75)
        ])

        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        image.image = UIImage(named: "pushup_step1.png")
        image2.image = UIImage(named: "pushup_step2.png")

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
        global_UserData.Add_Exercise_Done(ExerciseName: "WALL PUSH-UP", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
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


