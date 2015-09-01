//
//  SettingsTableViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 9/1/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var name: UILabel!

    @IBOutlet var sound: UISwitch!
    
    @IBOutlet var notification: UISwitch!
    @IBOutlet var threshold: UITextField!
    
    @IBAction func logout(sender: UIButton) {
        MANAGER.logout() { success in
            dispatch_async(dispatch_get_main_queue(), {() in
                if success {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.resetAppToFirstController()
                    
                }else{
                    
                    
                    
                }
            })
        }
    }
    
    @IBAction func configureSound(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var threshold = defaults.integerForKey("\(MANAGER.CUR_PROJECT.id)")
        if sender.on {
            self.threshold.enabled  = true
            threshold = (MANAGER.CUR_PROJECT.capacity % 1000) + 1
            defaults.setInteger(threshold, forKey: "\(MANAGER.CUR_PROJECT.id)")
        }else{
            self.threshold.enabled  = false
             defaults.setInteger(-1, forKey: "\(MANAGER.CUR_PROJECT.id)")
        }

        defaults.synchronize()
         NSNotificationCenter.defaultCenter().postNotificationName("updateSetting", object: nil)

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        threshold.resignFirstResponder()
        let defaults = NSUserDefaults.standardUserDefaults()
      println("setSoundThreshold \(textField.text.toInt())")
        defaults.setInteger(textField.text.toInt()!, forKey: "\(MANAGER.CUR_PROJECT.id)")
        defaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("updateSetting", object: nil)
        return true
    }
    
    @IBAction func setSoundThreshold(sender: UITextField) {
        println("setSoundThreshold \(sender.text.toInt())")
        
    }

    @IBAction func configureNotification(sender: UISwitch) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = MANAGER.user.name
        let defaults = NSUserDefaults.standardUserDefaults()
        var t = defaults.integerForKey("\(MANAGER.CUR_PROJECT.id)")
        threshold.text = "\(t)"
        if t == -1 {
            sound.setOn(false, animated: true)
        }else{
            sound.setOn(true, animated: true)
        }
        self.tableView.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel.textColor = UIColor(red: 151.0/255, green: 193.0/255, blue: 100.0/255, alpha: 1)
       // let font = UIFont(name: "Montserrat", size: 18.0)
       // headerView.textLabel.font = font!
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

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
