//
//  E2ViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-29.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class E2ViewController: UIViewController {
    @IBOutlet weak var DurationLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var SelectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor

        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        // page name
        let pageName = UILabel()
        pageName.text = "SINGLE LEG STANCE"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        
        DescriptionLabel.DescriptionDurationDesign()
        DurationLabel.DescriptionDurationDesign()
        SelectButton.DesignSelect()
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
