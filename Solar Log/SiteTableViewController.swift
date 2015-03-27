//
//  PlantTableViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/18/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class SiteTableViewController: UITableViewController {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    var sites:[Site] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Mock Site
        var site = Site(id: 101, name: "Demo 1")
        site.size = 3
        sites.append(site)
        site = Site(id: 102, name: "Demo 2")
        site.size = 3
        sites.append(site)
        site = Site(id: 103, name: "Demo 3")
        site.size = 5
        sites.append(site)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as SiteTableViewCell
        var site = sites[indexPath.row]
        cell.site = site
        
        //cell.image.image = UIImage(named: "watchkit-intro")
        cell.siteName.text = "\(site.name)"
        cell.siteId.text = "\(site.id)"
        cell.size.text = "\(site.size) MW"
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         //println("select = \(indexPath.row)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let index = tableView.indexPathForSelectedRow()
        /*
        var cell = sender as SiteTableViewCell
        MANAGER.CUR_SITE = cell.site
        if let idx = index {
            var site:Site = sites[idx.row]
            println("idx = \(idx.row) site= \(site.id)")
            MANAGER.CUR_SITE = site
        }*/
        if segue.identifier == "siteSeque" {

            if let idx = index {
                var site:Site = sites[idx.row]
                println("idx = \(idx.row) site= \(site.id)")
                MANAGER.CUR_SITE = site
            }
            
            
        }
    }



    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
