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
    //var refreshTrendGraph = TrendViewController()
   
    
    // view controllers in PageViewController
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "RoutinesPage"),
                self.newVc(viewController: "CategoriesPage"),
                self.newVc(viewController: "TrendsPage"),
                self.newVc(viewController: "SettingsPage")]
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        logNavigationStack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        global_StepTracker.track_steps() //call step counter
        print("Recommendation Made:\(global_UserRecommendation.checkUserAns())")
        self.dataSource = self
        
                                    /* NAVIGATION BAR CODE */
        //self.navigationController?.navigationBar.topItem!.title = "ROUTINES"                     // default title
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color

        // make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
//        self.navigationController?.transparentNavBar()
        
        // just show back arrow
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
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
        
        // dynamic title for navigation bar
//        if self.pageControl.currentPage == 0 { self.navigationController?.navigationBar.topItem!.title = "ROUTINES" }
//        else if self.pageControl.currentPage == 1 { self.navigationController?.navigationBar.topItem!.title = "CATEGORIES" }
//        else if self.pageControl.currentPage == 2 { self.navigationController?.navigationBar.topItem!.title = "TRENDS" }
//        else { self.navigationController?.navigationBar.topItem!.title = "SETTINGS" }
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
