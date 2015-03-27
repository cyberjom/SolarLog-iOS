//
//  EnergyViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController ,UITabBarDelegate {
    
    @IBOutlet var tabBar: UITabBar!
    
    var dayView : UIViewController?
    var monthView : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.delegate = self
        if (dayView == nil) {
            dayView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DayView") as? UIViewController
        }
        if let v = dayView?.view {
           // self.view.insertSubview(v, belowSubview: self.tabBar)
        }
       // tabBar.select(<#sender: AnyObject?#>)
    }
    override func viewDidAppear(animated: Bool) {
        if let v = dayView?.view {
           self.view.insertSubview(v, belowSubview: self.tabBar)
        }
    }

    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch (item.tag) {
        case 1:
            if (dayView == nil) {
                dayView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DayView") as? UIViewController
             }
            if let v = dayView?.view {
                self.view.insertSubview(v, belowSubview: self.tabBar)
            }
            break;
        case 2:
            if (monthView == nil) {
                monthView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MonthView") as? UIViewController
            }
            if let v = monthView?.view {
                self.view.insertSubview(v, belowSubview: self.tabBar)
            }
            
            
            break;
        default:
            break;
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
