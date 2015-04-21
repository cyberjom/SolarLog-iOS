//
//  LoginViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var user: UITextField!
    
    @IBOutlet var passwd: UITextField!
    
    @IBOutlet var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.view.center;
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        indicator.startAnimating()
        MANAGER.sso() { success, message, result in
            if success {
                MANAGER.projects(){ projects in
                    
                    if projects.count > 0 {
                        MANAGER.CUR_PROJECT = projects[0]
                        
                        dispatch_async(dispatch_get_main_queue(), {() in
                            self.performSegueWithIdentifier("Login", sender: nil)
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {() in
                            var alert = UIAlertController(title: "Alert", message: "No project available", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            indicator.stopAnimating()
                        })
                        
                    }
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), {() in
                    self.message.text = message
                    indicator.stopAnimating()
                })
                
            }
            
        }

        // Do any additional setup after loading the view.
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
    
    @IBAction func login(sender: UIButton) {
        MANAGER.login(user.text, passwd: passwd.text) { success, message, result in
            if success {
                MANAGER.projects(){ projects in
                    if projects.count > 0 {
                        MANAGER.CUR_PROJECT = projects[0]
                        dispatch_async(dispatch_get_main_queue(), {() in
                            self.performSegueWithIdentifier("Login", sender: nil)
                        })
                    }else{
                        
                    }
                }

            }else{
                dispatch_async(dispatch_get_main_queue(), {() in
                    
                    self.message.text = message
                })
                
            }
        }
    }
    
    @IBAction func demoLogin(sender: UIButton) {
        MANAGER.login("demo", passwd: "demodemo") { success, message, result in
            if success {
                MANAGER.projects(){ projects in
                    if projects.count > 0 {
                        MANAGER.CUR_PROJECT = projects[0]
                        dispatch_async(dispatch_get_main_queue(), {() in
                            self.performSegueWithIdentifier("Login", sender: nil)
                        })
                    }else{
                        
                    }
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), {() in
                    
                    self.message.text = message
                })
                
            }
        }
    }
    
}
