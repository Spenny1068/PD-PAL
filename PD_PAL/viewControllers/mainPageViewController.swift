//
//  mainPageViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
REVISION HISTORY:
 <Date, Name, Changes made>
 <Oct. 27, 2019, Spencer Lall, Setup navigation bar and code refactor>
 <Oct. 30, 2019, Julia Kim, Added step counter instance to call track_steps upon the app launch>
 
 */

import UIKit

class mainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()

    // view controllers in PageViewController
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "RoutinesPage"),
                self.newVc(viewController: "CategoriesPage"),
                self.newVc(viewController: "TrendsPage"),
                self.newVc(viewController: "SettingsPage")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        global_StepTracker.track_steps() //call step counter
        self.dataSource = self
        
                                    /* MAIN PAGE NAVIGATION BAR CODE */
        
        self.navigationController?.navigationBar.topItem!.title = "Main"           // nav bar text
        self.navigationController?.navigationBar.barTintColor = Setup.m_bgColor     // nav bar color
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "logo.png"), style: .plain, target: self, action: #selector(homeButtonTapped))
        //self.navigationItem.rightBarButtonItem  = homeButton
        
        
                                    /* PAGE VIEW CONTROLLER CODE */
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        self.delegate = self
        configurePageControl()
    }
    
                                    /* MAIN PAGE VIEW CONTROLLER FUNCTIONS */
    
    // when home button on nav bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "mainPage")
        present(homeView!, animated: true, completion: nil)
        
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height:50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {return nil}
        let prevIndex = viewControllerIndex - 1
        guard prevIndex >= 0 else {
            return orderedViewControllers.last
        }
        guard orderedViewControllers.count > prevIndex else{
            return nil
        }
        
        return orderedViewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
       
        let nextIndex = viewControllerIndex + 1
        guard orderedViewControllers.count != nextIndex else { return orderedViewControllers.first }
        guard orderedViewControllers.count > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
