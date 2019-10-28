//
//  CategoriesViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

// REVISION HISTORY:
// <Date, Name, Changes made>
// <Oct. 26, 2019, Spencer Lall, added categories buttons>
// <October 27, 2019, Spencer Lall, applied default page design>


import UIKit

class CategoriesViewController: UIViewController {

    // category button
    @IBOutlet weak var flexibility: UIButton!
    @IBOutlet weak var cardio: UIButton!
    @IBOutlet weak var strength: UIButton!
    @IBOutlet weak var balance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Setup.m_bgColor
        
        // get screen dimensions
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width     // width of view controller
        let screenHeight = screenRect.size.height   // height of view controller
        
        // PD_PAL header top right of screen
        let label = UILabel(frame: CGRect.zero)
        label.text = "PD_PAL"
        label.textAlignment = .center                                           // text alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(20)                                    // font size
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 250),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: -45),   // 15 points left of right view anchor
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),         // 10 points below top of view
            ])
        
        
        // Page Name
        let pageName = UILabel()
        pageName.text = "CATEGORIES"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        //NSLayoutConstraint.activate([
        //    pageName.widthAnchor.constraint(equalToConstant: 300),
        //    pageName.heightAnchor.constraint(equalToConstant: 50),
        //    pageName.leftAnchor.constraint(equalToConstant: 115),   /
        //    pageName.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75),
        //    ])

        
        // message
        let msg = UILabel()
        msg.text = "Choose a category to work!"
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
        
        //NSLayoutConstraint.activate([
        //   msg.widthAnchor.constraint(equalToConstant: 300),
        //    msg.heightAnchor.constraint(equalToConstant: 50),
        //   msg.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 115),
        //   msg.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
        //   ])
        
        // flexiblity button
        flexibility.frame = CGRect(x: screenWidth/2 - 150, y: screenHeight/2 - 150, width: 100, height: 150)
        let flexibilityImage = UIImage(named: "flexibility.png")
        flexibility.setImage(flexibilityImage , for: UIControl.State.normal)
        flexibility.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(flexibility)

        let flexibilityText = UILabel(frame: CGRect(x: screenWidth/2 - 150, y: screenHeight/2, width: 100, height: 30))
        flexibilityText.text = "Flexiblity"
        flexibilityText.textAlignment = .center                                           // text alignment
        //flexibilityText.backgroundColor = .red
        self.view.addSubview(flexibilityText)
        
        // strength button
        strength.frame = CGRect(x: screenWidth/2 - 150, y: screenHeight/2 + 100, width: 100, height: 150)
        let strengthImage = UIImage(named: "strength.png")
        strength.setImage(strengthImage , for: UIControl.State.normal)
        strength.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(strength)
        
        let strengthText = UILabel(frame: CGRect(x: screenWidth/2 - 150, y: screenHeight - 80, width: 100, height: 30))
        strengthText.text = "Strength"
        strengthText.textAlignment = .center                                           // text alignment
        //strengthText.backgroundColor = .blue
        self.view.addSubview(strengthText)

        
        // balance button
        balance.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 + 100, width: 100, height: 150)
        let balanceImage = UIImage(named: "balance.png")
        balance.setImage(balanceImage , for: UIControl.State.normal)
        balance.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(balance)
        
        let balanceText = UILabel(frame: CGRect(x: screenWidth/2 + 50, y: screenHeight - 80, width: 100, height: 30))
        balanceText.text = "Balance"
        balanceText.textAlignment = .center                                           // text alignment
        //balanceText.backgroundColor = .yellow
        self.view.addSubview(balanceText)

        // cardio button
        cardio.frame = CGRect(x: screenWidth/2 + 50, y: screenHeight/2 - 150, width: 100, height: 150)
        let cardioImage = UIImage(named: "cardio.png")
        cardio.setImage(cardioImage , for: UIControl.State.normal)
        cardio.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(cardio)
        
        let cardioText = UILabel(frame: CGRect(x: screenWidth/2 + 50, y: screenHeight/2, width: 100, height: 30))
        cardioText.text = "Cardio"
        cardioText.textAlignment = .center                                           // text alignment
        //balanceText.backgroundColor = .yellow
        self.view.addSubview(cardioText)
    
    }
    
@objc func buttonAction(sender: UIButton!) {
    print("button tapped")
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
