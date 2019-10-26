//
//  RoutineGenericViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-25.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class RoutineGenericViewController: UIViewController {
    @IBOutlet var ExerciseButton: UIButton!
    @IBOutlet var Exercise2Button: UIButton!
    @IBOutlet var Exercise3Button: UIButton!
    @IBOutlet var RoutineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExerciseButton.applyDesign()
        Exercise2Button.applyDesign()
        Exercise3Button.applyDesign()
        
        
        RoutineButton.backgroundColor = UIColor.red
        RoutineButton.setTitleColor(UIColor.black, for: .normal)
        RoutineButton.layer.shadowColor = UIColor.red.cgColor
        RoutineButton.layer.shadowRadius = 4
        RoutineButton.layer.shadowOpacity = 0.5
        RoutineButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        
        
        
      
        
        // Do any additional setup after loading the view.
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
//This extension can be applied to any ViewController that we make
extension UIButton
{
    func applyDesign()
    {
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
}


