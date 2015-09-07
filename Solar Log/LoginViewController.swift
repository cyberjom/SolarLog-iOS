//
//  LoginViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var user: UITextField!
    
    @IBOutlet var passwd: UITextField!
    
    @IBOutlet var message: UILabel!
    
    var kbHeight: CGFloat!
    var curField : Int! = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //user.delegate = self
        passwd.delegate = self
        


        
        var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.view.center;
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        indicator.startAnimating()
        MANAGER.sso() { success, message, result in
            if success {
                //TODO  send token
                let defaults = NSUserDefaults.standardUserDefaults()
                var token:String = ""
                if let deviceTokenString = defaults.stringForKey("token") {
                    token = deviceTokenString
                }
                
                self.updateToken(token)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        curField = textField.tag
        return true
    }
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight + user.frame.height  : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            if self.curField == 0 {
                self.view.frame.origin.y = movement
            }
            //self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
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
                
                //TODO  send token
                let defaults = NSUserDefaults.standardUserDefaults()
                var token:String = ""
                if let deviceTokenString = defaults.stringForKey("token") {
                    token = deviceTokenString
                }

                self.updateToken(token)
                
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
    func updateToken(token:String){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://10.2.1.112:3000/users/regis_token")!)
        
        request.HTTPMethod = "POST"
        
        var deviceUUid:String = UIDevice.currentDevice().identifierForVendor.UUIDString;
        
        var err: NSError?
        
        var params = "token=\(token)&uid=\(MANAGER.user.id)&UUID=\(deviceUUid)";
        println("params=\(params)")
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            
            println(response)
            
            if parseError != nil {
                println("submir error: \(parseError!.localizedDescription)")
                
            }else if (jsonResult != nil) {
                println(jsonResult)
                var result = jsonResult as! NSDictionary
                
                
            }
            }.resume()
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
