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

    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var DurationLabel: UILabel!
    @IBOutlet var SelectButton: UIButton!
    @IBOutlet var DurationText: UITextView!
    @IBOutlet var DescriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // read exercise info into labels
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: "WALL PUSH-UP")
        DescriptionText.text = readResult.Description
        DurationText.text = readResult.Duration
        
        DescriptionLabel.DescriptionDurationDesign()
        DurationLabel.DescriptionDurationDesign()
        SelectButton.DesignSelect()
        
        // page name
        let pageName = UILabel(frame: CGRect.zero)
        pageName.text = "QUAD STRETCH"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        NSLayoutConstraint.activate([
            pageName.widthAnchor.constraint(equalToConstant: 350),
            pageName.heightAnchor.constraint(equalToConstant: 50),
            pageName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            pageName.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75)
        ])
        
        
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

