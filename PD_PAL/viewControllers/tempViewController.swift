//
//  tempViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-11-15.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class tempViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    /* global variables */
    var exercise_name2: String!
    var exercise_number = 1

    // -> timer variables
    var seconds = 5            // get this value from db
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* use segue to forward pass exercise name to destination exercise view controller */
        if segue.identifier == "SkipSegue" {
            let vc = segue.destination as! ExerciseViewController
            
            /* reached the end of routine */
            if Global.routine_index >= 2 {
                
                /* navigate to main page */
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
                self.present(newViewController, animated: true, completion: nil)
            }
            
            else {
                /* update variables to properly reload next exercise VC */
                Global.next_routine_exercise = Global.routine_data[Global.routine_index + 1]
                Global.routine_index += 1
            }
        }
    }
    
    /* put code that depends on IsRoutineExercise flag in here */
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            /* navigation bar home button */
            let homeButton = UIButton(type: .custom)
            homeButton.applyHomeButton()
            homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: homeButton)
            self.navigationItem.rightBarButtonItem  = barButton
            self.title = nil
            
            
            if Global.next_routine_exercise != "" { self.exercise_name2 = Global.next_routine_exercise }
            Global.next_routine_exercise = ""
            
            
            
            /* populate exercise description */
            let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name2 ?? "nil")
            self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
            
            /* page message */
            self.show_page_message(s1: exercise_name2 ?? "Unable to retrieve exercise name", s2: exercise_name2 ?? "nil")
            
            /* stop button */
            stopButton.timerButtonDesign()
            stopButton.setTitle("STOP", for: .normal)
            stopButton.backgroundColor = Global.color_schemes.m_lightRed
            //self.view.addSubview(stopButton)
            
            /* completed Button */
            completedButton.timerButtonDesign()
            completedButton.setTitle("COMPLETED", for: .normal)
            completedButton.backgroundColor = Global.color_schemes.m_blue2
            //self.view.addSubview(completedButton)
            
            /* timer label */
            timerLabel.timerDesign()
            
            /* Skip button */
            skipButton.skipButtonDesign()
            skipButton.setTitle("SKIP",for: .normal)
            skipButton.backgroundColor = Global.color_schemes.m_lightGreen
            
            /* start button */
            startButton.timerButtonDesign2()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            
            let exercise_data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name2)
            
//            /* gif */
//            guard let gif = UIImageView.fromGif(frame: CGRect(x: 0, y: 112, width: 375, height: 300), resourceName: exercise_data.Link) else { return }
//            view.addSubview(gif)
//            gif.startAnimating()
            
            /* when entering this page, hide these elements */
            stopButton.isHidden = true
            timerLabel.isHidden = true
            completedButton.isHidden = true
            
            startButton.isHidden = false
            skipButton.isHidden = false
            
            /* last exercise */
            if Global.routine_index == 2 {
                skipButton.setTitle("EXIT ROUTINE",for: .normal)

            }
            
            print ("log: routine_index: ", Global.routine_index)
            print ("log: link: ", exercise_data.Link)
            print ("log: exercise_name: ", exercise_name2)
            print ("log: tempViewController")
            print ("log: next_routine_exercise", Global.next_routine_exercise)

        }
        
        /* put code that does not depends on IsRoutineExercise flag in here */
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = Global.color_schemes.m_bgColor  // background color
            
            /* when entering this page, hide these elements */
            stopButton.isHidden = true
            timerLabel.isHidden = true
            completedButton.isHidden = true
            
            /* when entering this page, show these elements */
            startButton.isHidden = false
            skipButton.isHidden = false
            
            /* navigation bar stuff */
                   self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                   self.title = nil
                   let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
                   self.navigationItem.rightBarButtonItem  = homeButton
        }
    
    @IBAction func startButton(_ sender: Any) {
        /* hide these elements */
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        skipButton.isHidden = true
        
        /* show these elements */
        stopButton.isHidden = false
        timerLabel.isHidden = false
        
        /* start timer */
        runTimer()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        /* reset timer value */
        timer.invalidate()
        seconds = 5                         // reset value
        timerLabel.text = "\(seconds)"
        
        /* show these elements */
        DescriptionLabel.isHidden = false
        DescriptionText.isHidden = false
        startButton.isHidden = false
        skipButton.isHidden = false
        
        /* hide these elements */
        stopButton.isHidden = true
        timerLabel.isHidden = true
    }
    
    @IBAction func completedButton(_ sender: Any) {
        /* parse Date() function into year, month, day, and hour */
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        /* insert excercise as done */
        global_UserData.Add_Exercise_Done(ExerciseName: exercise_name2 ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        
        /* last excercise */
        if Global.routine_index == 2 {
            print ("log: completed button tapped on last excercise")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
        
        /* when home button on navigation bar is tapped */
        @objc func homeButtonTapped(sender: UIButton!) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
        }
    
        /* starts timer */
        func runTimer() {
             timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        }
        
        /* decrements timer */
        @objc func updateTimer() {
            seconds -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)" //This will update the label.
            
            /* when countdown is done, hide and show these elements */
            if seconds <= 0 {
                stopButton.isHidden = true
                completedButton.isHidden = false
                timer.invalidate()
            }
        }
    
    
    }



    
