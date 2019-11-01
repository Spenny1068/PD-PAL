//
//  OneLegSquatViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision Histroy
// <date, name, update change>
// <October 31st 2019, Arian Vafadar, Created and designed Quad Stretch page>
//

import UIKit

class OneLegSquatViewController: UIViewController {

    @IBOutlet var ExerciseLabel: UILabel!
    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var DurationLabel: UILabel!
    @IBOutlet var SelectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExerciseLabel.ExerciseDesign()
        DescriptionLabel.DescriptionDurationDesign()
        DurationLabel.DescriptionDurationDesign()
        SelectButton.DesignSelect()
        
        
        
        

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

extension UILabel
{
    func ExerciseDesign()
    {
        self.backgroundColor = UIColor.init(red: 222/255, green: 124/255, blue: 11/255, alpha: 1)
        self.textColor = UIColor.white                          // text color
    }
    func DescriptionDurationDesign()
    {
        self.backgroundColor = UIColor.black                   // background color
        self.textColor = UIColor.white                          // text color
    }
}
extension UIButton
{
    func DesignSelect()
    {
        self.backgroundColor = UIColor.init(red: 54/255, green: 141/255, blue: 241/255, alpha: 1)
        self.setTitleColor(UIColor.white, for: .normal)                        // text color
    }
}

