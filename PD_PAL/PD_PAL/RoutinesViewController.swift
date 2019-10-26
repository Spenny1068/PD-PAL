//
//  RoutinesViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class RoutinesViewController: UIViewController {

    @IBOutlet var Routine1Button: UIButton!
    @IBOutlet var Routine2Button: UIButton!
    @IBOutlet var Routine3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Routine1Button.RoutineDesign()
        Routine2Button.RoutineDesign()
        Routine3Button.RoutineDesign()

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

extension UIButton
{
    func RoutineDesign()
    {
        self.backgroundColor = UIColor.black
        self.setTitleColor(UIColor.white, for: .normal)
    }
}

