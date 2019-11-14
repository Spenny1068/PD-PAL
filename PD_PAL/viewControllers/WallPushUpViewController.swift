//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class WallPushUpViewController: UIViewController {
    
    // IBOutlet Labels
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // IBOutlet buttons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    
    // global timer variables
    var seconds = 5            // get this value from db
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    // called when start button is tapped
    @IBAction func startButton(_ sender: Any) {
        // hide exercise description and start button
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        
        // show stop button and timer
        stopButton.isHidden = false
        timerLabel.isHidden = false
        
        // start timer
        runTimer()
    }
    
    // called when stop button is tapped
    @IBAction func stopButton(_ sender: Any) {
        
        // reset timer value
        timer.invalidate()
        seconds = 5    // reset value
        timerLabel.text = "\(seconds)"
        
        // show description and start button
        DescriptionLabel.isHidden = false
        DescriptionText.isHidden = false
        startButton.isHidden = false
        
        // hide stop button and timer
        stopButton.isHidden = true
        timerLabel.isHidden = true
    }
    
    // called when completed button is tapped
    @IBAction func completedButton(_ sender: Any) {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        // insert excercise as done
        global_UserData.Add_Exercise_Done(ExerciseName: "WALL PUSH-UP", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
    }
    
    /* code in here will execute based Global.IsRoutineExercise value */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // we came from routines
        if Global.IsRoutineExercise == 1 {
            let skipButton = UIButton()
            skipButton.setTitle("Skip",for: .normal)
            skipButton.setTitleColor(.red , for: .normal) //change colour later
            skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            skipButton.frame = CGRect(x: 25, y: 550, width: 50, height: 100)
            self.view.addSubview(skipButton)
        }
            
        // we came from categories
        else if Global.IsRoutineExercise == 0 {
            
            // start button
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
            
            // stop button
            stopButton.timerButtonDesign()
            stopButton.setTitle("STOP", for: .normal)
            stopButton.backgroundColor = Global.color_schemes.m_lightRed
            self.view.addSubview(stopButton)
            
            // completed Button
            completedButton.timerButtonDesign()
            completedButton.setTitle("COMPLETED", for: .normal)
            completedButton.backgroundColor = Global.color_schemes.m_blue2
            self.view.addSubview(completedButton)
            
            // timer label
            timerLabel.timerDesign()
            self.view.addSubview(timerLabel)
            
            // gif
            guard let gif = UIImageView.fromGif(frame: CGRect(x: 0, y: 112, width: 375, height: 300), resourceName: "neck_side_stretch") else { return }
            view.addSubview(gif)
            gif.startAnimating()

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // remove back button
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue1                      // background color
        self.title = nil                                                                                            // remove page title

        // page message
        self.show_page_message(s1: "WALL PUSH-UP", s2: "WALL PUSH-UP")
        
        // hide the stop button, completed button, and timer
        stopButton.isHidden = true
        timerLabel.isHidden = true
        completedButton.isHidden = true
        
        // read exercise info into labels
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: "WALL PUSH-UP")
        
        // exercise description
        self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
        
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
    
    // called when skip button is tapped
    @objc func skipButtonTapped() {
        //let nextExercise = Name of viewController for exercise
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    // starts timer
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // decrements timer
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        
        if seconds <= 0 {
            // hide the stop button and show completed button
            stopButton.isHidden = true
            completedButton.isHidden = false
        }
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}


