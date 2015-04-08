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
        MANAGER.sso() { success, message, result in
            dispatch_async(dispatch_get_main_queue(), {() in
                if success {
                    
                    self.performSegueWithIdentifier("Login", sender: nil)
                    
                    
                }else{
                    
                    self.message.text = message
                    
                    
                }
            })
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
            dispatch_async(dispatch_get_main_queue(), {() in
                if success {
                    
                    self.performSegueWithIdentifier("Login", sender: nil)
                    
                    
                }else{
                    
                    self.message.text = message
                    
                    
                }
            })
        }
    }
}
