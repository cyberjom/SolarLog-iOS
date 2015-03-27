//
//  SiteInfoViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/24/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class SiteInfoViewController: UIViewController {

    @IBOutlet var siteid: UILabel!
    
    @IBOutlet var sitename: UILabel!
    
    @IBOutlet var size: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var site = MANAGER.CUR_SITE
        
        siteid.text = "\(site.id)"
        sitename.text = site.name
        size.text = "\(site.size) MW"
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
         var site = MANAGER.CUR_SITE
        siteid.text = "\(site.id)"
        sitename.text = site.name
        size.text = "\(site.size) MW"
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
