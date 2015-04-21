//
//  SiteInfoViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/24/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class ProjectInfoViewController: UIViewController {

    @IBOutlet var projectid: UILabel!
    
    @IBOutlet var projectname: UILabel!
    
    @IBOutlet var location: UILabel!

    @IBOutlet var province: UILabel!
    
    @IBOutlet var capacity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var project = MANAGER.CUR_PROJECT
        
        projectid.text = "\(project.id)"
        projectname.text = project.name
        location.text = "\(project.location)"
        province.text = "\(project.province)"
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
         var project = MANAGER.CUR_PROJECT
        
        projectid.text = "\(project.id)"
        projectname.text = project.name
        location.text = "\(project.location)"
        province.text = "\(project.province)"
        capacity.text = "\(project.capacity) w"
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
