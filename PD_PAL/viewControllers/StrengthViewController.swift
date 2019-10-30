//
//  StrengthViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>
import UIKit

class StrengthViewController: UIViewController {

    @IBOutlet weak var ArmsButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var CoreButton: UIButton!
    @IBOutlet weak var LegsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // [UIButton, buttonWithType,:UIButtonTypeSystem]
        
        
        view.backgroundColor = Setup.m_bgColor

        // page name
        let pageName = UILabel()
        pageName.text = "STRENGTH"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        
        // message
        let msg = UILabel()
        msg.text = "Choose a body part!"
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
        
        ArmsButton.applyDesign()
        BackButton.applyDesign()
        CoreButton.applyDesign()
        LegsButton.applyDesign()
        
        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton

        /* need to change button type to Custom in xib file to load picture */
        //let logo = UIImage(named: "logo.png")
        //homeButton.image = logo
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
