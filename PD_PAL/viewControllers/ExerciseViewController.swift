//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    /* IBOutlet Labels */
    @IBOutlet weak var LoadingLabel: UILabel!
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var SetsLabel: UILabel!
    
    /* IBOutlet buttons */
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var exitRoutineButton: UIButton!
    @IBOutlet weak var NextSetButton: UIButton!
    
    /* global variables */
    var exercise_name: String!
    var imageView = UIImageView()
    var seconds: Int = 0
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* skip segue updates global variables to reload page with next excercise */
        if segue.identifier == "SkipSegue" {
            if Global.routine_index < 0 { Global.routine_index = 0 }
            let vc = segue.destination as! tempViewController
            Global.next_routine_exercise = Global.routine_data[Global.routine_index + 1]
            Global.routine_index += 1
        }
    }
    
    /* put code that depends on IsRoutineExercise flag in here */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if Global.next_routine_exercise != "" { self.exercise_name = Global.next_routine_exercise }
        Global.next_routine_exercise = ""
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIButton(type: .custom)
        homeButton.applyHomeButton()
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.rightBarButtonItem  = barButton
        
        /* populate exercise description */
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
        
        /* page message */
        self.show_page_message(s1: exercise_name ?? "Unable to retrieve exercise name", s2: exercise_name ?? "nil")
        
        
        /* Dynamic elements */
        
        //-> stop button
        stopButton.applyDefaultTimerButtonFrame()
        stopButton.timerButtonDesign()
        stopButton.setTitle("STOP", for: .normal)
        stopButton.backgroundColor = Global.color_schemes.m_lightRed
        self.view.addSubview(stopButton)
        
        //-> completed Button
        completedButton.applyRightTimerButtonFrame()
        completedButton.timerButtonDesign()
        completedButton.setTitle("COMPLETED", for: .normal)
        completedButton.backgroundColor = Global.color_schemes.m_blue2
        self.view.addSubview(completedButton)
        
        //-> next set button
        NextSetButton.applyLeftTimerButtonFrame()
        NextSetButton.timerButtonDesign()
        NextSetButton.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        NextSetButton.setTitle("NEXT SET", for: .normal)
        NextSetButton.backgroundColor = Global.color_schemes.m_lightGreen
        
        //-> timer label
        timerLabel.timerAndSetsDesign()
        timerLabel.applyTimerLabelFrame()
        self.view.addSubview(timerLabel)
        
        //-> sets label
        SetsLabel.timerAndSetsDesign()
        SetsLabel.applySetsLabelFrame()
        SetsLabel.text = "\(readResult.Sets)"
        
        /* when entering this page, hide these elements */
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
        completedButton.isHidden = true
        exitRoutineButton.isHidden = true
        NextSetButton.isHidden = true
        
        DescriptionText.isHidden = false
        DescriptionLabel.isHidden = false
        LoadingLabel.isHidden = false
        
        /* we came from routines page */
        if Global.IsRoutineExercise == 1 {
            
            /* Skip button */
            skipButton.applyLeftTimerButtonFrame()
            skipButton.timerButtonDesign()
            skipButton.setTitle("SKIP",for: .normal)
            skipButton.backgroundColor = Global.color_schemes.m_lightGreen
            skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            self.view.addSubview(skipButton)
            
            /* start button */
            startButton.applyRightTimerButtonFrame()
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
        }
            
        /* we came from categories page */
        else if Global.IsRoutineExercise == 0 {
            
            /* start button */
            startButton.applyDefaultTimerButtonFrame()
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
        }
        
        /* last exercise */
        if Global.routine_index == 2 {
            skipButton.isHidden = true
            exitRoutineButton.applyLeftTimerButtonFrame()
            exitRoutineButton.setTitle("EXIT ROUTINE", for: .normal)
            exitRoutineButton.backgroundColor = Global.color_schemes.m_lightRed
            exitRoutineButton.timerButtonDesign()
            exitRoutineButton.isHidden = false
        }
        
        /* testing */
        //print ("log: routine_index: ", Global.routine_index)
//        print ("log: exercise_name: ", exercise_name)
//        //print ("log: link: ", exercise_data.Link)
//        print ("log: ExerciseViewController")
//        print ("log: next_routine_exercise", Global.next_routine_exercise)
    }
    
    /* put code that does not depends on IsRoutineExercise flag in here */
    override func viewDidLoad() {
        logNavigationStack()
        
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* when entering this page, hide these elements */
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
        completedButton.isHidden = true
        exitRoutineButton.isHidden = true
        NextSetButton.isHidden = true
        
        /* when entering this page, show these elements */
        startButton.isHidden = false
        skipButton.isHidden = false
    }
    
    /* put slow code in here to run on a different thread */
    override func viewDidAppear(_ animated: Bool) {
        
        let temp = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        var gif = UIImage.gifImageWithName(temp.Link)
        imageView = UIImageView(image: gif)
        imageView.frame = CGRect(x: 0, y: 112, width: 375, height: 300)
        view.addSubview(imageView)
        
        /* hide loading label when gif has loaded */
        LoadingLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /* if back button is pressed */
        if self.isMovingFromParent {
            if Global.routine_index > 0 { Global.routine_index = Global.routine_index - 1 }
        }
    }
    
    
    /* when start button is tapped */
    @IBAction func startButton(_ sender: Any) {
        
        /* hide these elements */
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        skipButton.isHidden = true
        exitRoutineButton.isHidden = true
        
        /* show these elements */
        stopButton.isHidden = false
        timerLabel.isHidden = false
        SetsLabel.isHidden = false
        
        /* start timer */
        runTimer()
    }
    
    /* when the exit routine button is tapped */
    @IBAction func exitRoutine(_ sender: Any) {
        
        /* navigate to main page */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
        
        exitRoutineButton.isHidden = true
    }
    
    /* when stop button is tapped */
    @IBAction func stopButton(_ sender: Any) {
        /* reset timer value */
        timer.invalidate()
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        seconds = data.Duration
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
    
    /* when completed button is tapped */
    @IBAction func completedButton(_ sender: Any) {
        
        /* parse Date() function into year, month, day, and hour */
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        /* insert excercise as done */
        global_UserData.Add_Exercise_Done(ExerciseName: exercise_name ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        
        /* kill running gif */
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
        
        /* if we came from categories */
        if Global.IsRoutineExercise == 0 {
            print ("log: completed button tapped on last excercise")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
        }
        
        /* last excercise */
        if Global.routine_index == 2 {
            
            /* navigate to home page */
            print ("log: completed button tapped on last excercise")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
            
            /* reset routine index */
            Global.routine_index = 0
        }
        
        /* if we came from routines */
        if Global.IsRoutineExercise == 1 {
            startButton.isHidden = false
            skipButton.isHidden = false
        }
    }
    
    /* when home button on navigation bar is tapped */
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
        
        /* kill running gif */
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
    }
    
    /* next set button is tapped  */
    @objc func nextSetButtonTapped(sender: UIButton!) {
        print ("next set button tapped")
        
        /* hide these elements */
        completedButton.isHidden = true
        
        /* show these elements */
        timerLabel.isHidden = false
        SetsLabel.isHidden = false
        
        /* start timer */
        runTimer()
    }
    
    /* skip button is tapped */
    @objc func skipButtonTapped() {
        /* kill running gif */
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
        
        print ("skip buttons tapped")
    }
    
    /* starts timer */
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        seconds = data.Duration
    }
    
    /* decrements timer */
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" + "s" //This will update the label.
        
        /* when countdown is done, hide and show these elements */
        if seconds <= 0 {
            stopButton.isHidden = true
            completedButton.isHidden = false
            NextSetButton.isHidden = false
            timer.invalidate()
        }
    }
}
