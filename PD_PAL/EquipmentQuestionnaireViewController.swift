//
//  EquipmentQuestionnaireViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class EquipmentQuestionnaireViewController: UIViewController {
    @IBOutlet weak var RBandCheckbox:UIButton!
    @IBOutlet weak var chairCheckbox:UIButton!
    @IBOutlet weak var weightsCheckbox:UIButton!
    @IBOutlet weak var poolCheckbox:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RBandCheckbox.setImage(UIImage(named:"Checkmarks"), for: .normal)
        RBandCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .selected)
        chairCheckbox.setImage(UIImage(named:"Checkmarks"), for: .normal)
        chairCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .selected)
        weightsCheckbox.setImage(UIImage(named:"Checkmarks"), for: .normal)
        weightsCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .selected)
        poolCheckbox.setImage(UIImage(named:"Checkmarks"), for: .normal)
        poolCheckbox.setImage(UIImage(named:"Unchecked marks"), for: .selected)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkMarkTapped(sender: UIButton){
        UIView.animate(withDuration:0.2, delay: 0.1, options: .curveLinear, animations:{
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){(success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
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
