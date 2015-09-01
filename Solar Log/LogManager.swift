//
//  LogManager.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/16/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import Foundation
import UIKit

let MANAGER = LogManager();
let URLS:[String] = ["http://solarlog.intersol.co.th/","http://solarlog.intersol.co.th/","http://nuangjamnong.com/"]

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let demoUser: User! = User(id: 0, name: "Demo")

class LogManager{
    var ACCESS_TOKEN:String = ""
    var CUR_URL:String = URLS[0]
    var CUR_PROJECT:Project = Project(id: 0, name: "Demo")
    var IS_DEMO:Bool = true
    var cookies:NSArray = NSArray()
    var projects:[Project] = []
    var powers:[GraphData] = []
    var processingSummary : Bool = false
    var lastSummary : Summary = Summary()
    //Default demo user

    var user : User = demoUser
    
    func changeProject(project:Project){
        if project.id != CUR_PROJECT.id {
            projects = []
        }
        CUR_PROJECT = project
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var threshold = defaults.integerForKey("\(project.id)")
        if threshold == 0 {
            threshold = (project.capacity / 10000) + 1
        }
        defaults.setInteger(threshold, forKey: "\(project.id)")
        defaults.synchronize()
        

        
    }
    func sso(completion: (success:Bool,message:String,user : User) ->()){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let user = defaults.stringForKey("user"){
            var error:NSError
            
            var password = Keychain.load(user)
            login(user, passwd: password! as String){ success, message, user in
                completion(success: success,message : message, user: user)
            }
            println(user)
        }else{
            completion(success: false,message : "Please enter username and password", user: demoUser)
        }
    }
    
    func login(user:String,passwd:String,completion: (success:Bool,message:String,user : User) ->()){
        
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/sign_in.json?username=\(user)&password=\(passwd)"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            //println(response)
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
               println("login \(parseError?.localizedDescription)")
                var msg = parseError?.localizedDescription
                completion(success: false,message : msg!, user:  demoUser)
                return
            }
            if (jsonResult != nil) {
               // println(jsonResult)
                var result = jsonResult as! NSDictionary
                if let status =  result["status"] as? String {
                    if status == "success" {
                        if user != "demo" {
                        let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(user, forKey: "user")
                            defaults.synchronize()
                            Keychain.save(passwd, forKey: user)
                        }
                        //Extract token from Session id maintain in cookie
                        var httpResp:NSHTTPURLResponse = response as! NSHTTPURLResponse
                        self.cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(httpResp.allHeaderFields, forURL: httpResp.URL!)
                        
                        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:////[response URL] mainDocumentURL:nil];
                        //if let t =  result["access_token"] as? String {
                            //self.ACCESS_TOKEN = t
                       // }
                        if let u =  result["user"] as? NSDictionary {
                            if let id =  u["id"] as? Int {
                               
                                var user = User(id: id)
                                if let name =  u["name"] as? String {
                                        user.name = name
                                }
                                self.user = user
                                completion(success: true, message : status,  user: user)
                                return
                             
                            }
                        }
                        
                    }else{
                        var message = ""
                        if let m =  result["message"] as? String {
                            message = m
                        }
                        completion(success: false, message :message , user: demoUser)
                        return
                    }
                   
                }
                
                completion(success: false,message : "Internal server error, Please try again later!", user:  demoUser)
            } else {

                completion(success: false,message : "Internal server error, Please try again later!", user:  demoUser)
            }
            }.resume()
    }
    
    func logout(completion: (success:Bool) ->()){
        let url = "\(CUR_URL)/sign_out.json?access_token=\(ACCESS_TOKEN)"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        //  var headers = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies)
        // [request setAllHTTPHeaderFields:headers];
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
           
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)

            
            if(parseError != nil){
                println("logout \(parseError?.localizedDescription)")
                return
            }
            var httpResp:NSHTTPURLResponse = response as! NSHTTPURLResponse
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(self.cookies as [AnyObject], forURL: httpResp.URL, mainDocumentURL: nil)
            if (jsonResult != nil) {
                println(jsonResult)
                var result = jsonResult as! NSDictionary
                if let status =  result["status"] as? String {
                    if status == "success" {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        if let user = defaults.stringForKey("user"){
                            Keychain.delete(user)
                        }
                        defaults.removeObjectForKey("user")
                        defaults.synchronize()
                        self.user = demoUser
                        completion(success: true)
                    }else{
                        completion(success: false)
                    }
                } else {
                    // couldn't load JSON, look at error
                    completion(success: false)
                }
            }
            }.resume()
            
    }
    
    func projects(completion: (projects : [Project]) ->()){
        if(!self.projects.isEmpty){
            completion(projects: self.projects)
        }else{
            
            MANAGER.syncProjects(){ projects in
                self.projects = []
                for p in projects{
                    self.projects.append(p)
                }
                 
                completion(projects: self.projects)
            }
        }
        
    }
    
    func syncProjects(completion: (projects : [Project]) ->()){
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/projects.json"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in

          
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println("projects \(parseError?.localizedDescription)")
                return
            }
            if (jsonResult != nil) {
                println("syncProjects \(jsonResult)")
                self.projects = []
                if let ss =  jsonResult as? NSArray {
                    for s in ss   {
                        var project:Project!
                        if let id =  s["id"] as? Int {
                            if let name =  s["name"] as? String {
                                project = Project(id: id, name: name)
                                if let location_name =  s["location_name"] as? String {
                                    project.location = location_name
                                }
                                if let province_name =  s["province_name"] as? String {
                                    project.province = province_name
                                }

                                if let capacity =  s["capacity"] as? Int {
                                    project.capacity = capacity
                                }
                                self.projects.append(project)
                            }
                        }
                        
                        
                    }
                }
               
                completion(projects: self.projects)
            } else {
                // couldn't load JSON, look at error
            }
            }.resume()

    }
    
    func summary(completion: (summary : Summary , hasUpdate : Bool) ->()){
        if processingSummary {
            completion(summary: lastSummary , hasUpdate: false)
            return
        }
        processingSummary = true
        var ts = NSDate().timeIntervalSince1970
        if CUR_PROJECT.id == 0 {
            return
        }
        let url = "\(CUR_URL)meter_reads/json/\(CUR_PROJECT.id)" //&ts=\(ts)"
        //println("url = \(url)")
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
       
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println("summary error \(parseError?.localizedDescription)")
                completion(summary: self.lastSummary , hasUpdate: false)
                self.processingSummary = false
                return
            }
            if (jsonResult != nil) {
              //  println(jsonResult)
                var result = jsonResult as! NSDictionary
                var summary = Summary()
            
                if let site_id =  result["site_id"] as? String {
                    summary.site_id = site_id
                }
                if let datetimeint =  result["datetime"] as? NSTimeInterval {
                   // let fmt = NSDateFormatter()
                   // fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    summary.datetime = NSDate(timeIntervalSince1970: datetimeint) //fmt.dateFromString(datetimestr)!
                }
                if let power =  result["power"] as? Double {
                    summary.power = power
                    
                    if ( self.powers.count >= 500 ) {
                        self.powers.removeAtIndex(0)
   
                    }
                    self.powers.append(GraphData(x: summary.datetime, y: power))
                    
                }

                if let energy =  result["energy"] as? NSDictionary {
                    if let month =  energy["month"] as? Double {
                        summary.energy.month = month
                    }
                    if let today =  energy["today"] as? Double {
                        summary.energy.today = today
                    }
                    if let total =  energy["total"] as? Double {
                        summary.energy.total = total
                    }
                    if let year =  energy["year"] as? Double {
                        summary.energy.year = year
                    }
                    if let revenuetoday =  energy["revenuetoday"] as? Double {
                        summary.energy.revenuetoday = revenuetoday
                    }
                }
                
                if let meteorologies =  result["meteorology"] as? NSArray {
                    for m in meteorologies   {

                    var meteorology = Meteorology()
                    if let irradiance =  m["irradiance"] as? Double {
                        meteorology.irradiance = irradiance
                    }
                    if let temperature =  m["temperature"] as? Double {
                        meteorology.temperature = temperature
                    }
                    if let humidity =  m["humidity"] as? Double {
                        meteorology.humidity = humidity
                    }
                    if let windspeed =  m["windspeed"] as? Double {
                        meteorology.windspeed = windspeed
                    }
                    if let precipitation =  m["precipitation"] as? Double {
                        meteorology.precipitation = precipitation
                    }
                    summary.meteorologies.append(meteorology)
                        
                    }
                }
               
           


                if let inverters =  result["inverter"] as? NSArray {
                    
                    for inv in inverters   {
                        var inverter:Inverter! = Inverter()
                        if let id =  inv["id"] as? Int {
                            inverter.id = id
                        }
                        if let V =  inv["V"] as? Double {
                            inverter.V = V
                        }
                        if let I =  inv["I"] as? Double {
                            inverter.I = I
                        }
                        if let status =  inv["status"] as? Double {
                            inverter.status = status
                        }
                        if let mppts =  inv["mppt"] as? NSArray {
                            for m in mppts   {
                                var mppt:Mppt! = Mppt()
                                if let id =  m["id"] as? Int {
                                    mppt.id = id
                                }
                                if let V =  m["V"] as? Double {
                                    mppt.V = V
                                }
                                if let strings =  m["string"] as? NSArray {
                                    for s in strings   {
                                        var string:MpptString! = MpptString()
                                        if let id =  s["id"] as? Int {
                                            string.id = id
                                        }
                                        if let I =  s["I"] as? Double {
                                            string.I = I
                                        }
                                        if let T =  s["T"] as? Double {
                                            string.T = T
                                        }
                                        mppt.strings.append(string)
                                    }
                                }
                                
                                inverter.mppts.append(mppt)
                                
                            }
                        }
                        
                        
                        summary.inverters.append(inverter)
                    }
                }
                self.lastSummary = summary
                self.processingSummary = false
                completion(summary: summary , hasUpdate: true)
            } else {
                // couldn't load JSON, look at error
                self.processingSummary = false
            }
            }.resume()
        
    }
    
    func energyDay(completion: (data : [GraphData]) ->()){
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/reports/energy/\(CUR_PROJECT.id)/day"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println("energyDay \(parseError?.localizedDescription)")
                
                return
            }
            if (jsonResult != nil) {
                //println(jsonResult)
                var data : [GraphData] = []
                var result = jsonResult as! NSDictionary
                if let ss =  result["data"] as? NSArray {
                    for s in ss   {
                        var d:GraphData!
                        if let x =  s["x"] as? Int {
                            if let y =  s["y"] as? Double {
                                d = GraphData(x: x,y: y)
                                
                                data.append(d)
                            }
                        }
                        
                        
                    }
                }
                
                completion(data: data)
            } else {
               completion(data: [])
            }
            }.resume()
        
    }
    
    func revenueDay(completion: (data : [GraphData]) ->()){
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/reports/revenue/\(CUR_PROJECT.id)/day"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println("energyDay \(parseError?.localizedDescription)")
                return
            }
            if (jsonResult != nil) {
                //println(jsonResult)
                var data : [GraphData] = []
                var result = jsonResult as! NSDictionary
                if let ss =  result["data"] as? NSArray {
                    for s in ss   {
                        var d:GraphData!
                        if let x =  s["x"] as? Int {
                            if let y =  s["y"] as? Double {
                                d = GraphData(x: x,y: y)
                                
                                data.append(d)
                            }
                        }
                        
                        
                    }
                }
                
                completion(data: data)
            } else {
                completion(data: [])
            }
            }.resume()
        
    }
    
    func energyMonth(completion: (data : [GraphData]) ->()){
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/reports/energy/\(CUR_PROJECT.id)/month"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println(parseError?.localizedDescription)
                return
            }
            if (jsonResult != nil) {
                println(jsonResult)
                var data : [GraphData] = []
                var result = jsonResult as! NSDictionary
                if let ss =  result["data"] as? NSArray {
                    for s in ss   {
                        var d:GraphData!
                        if let x =  s["x"] as? String {
                            if let y =  s["y"] as? Double {
                                d = GraphData(x: x,y: y)
                                
                                data.append(d)
                            }
                        }
                        
                        
                    }
                }
                
                
                completion(data: data)
            } else {
                completion(data: [])
            }
            }.resume()
        
    }
    
    func revenueMonth(completion: (data : [GraphData]) ->()){
        
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/reports/revenue/\(CUR_PROJECT.id)/month"
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData;
        
        
        var session = NSURLSession(configuration: configuration)
        
        
        session.dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            
            
            var parseError: NSError?
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            if(parseError != nil){
                println(parseError?.localizedDescription)
                return
            }
            if (jsonResult != nil) {
                println(jsonResult)
                var data : [GraphData] = []
                var result = jsonResult as! NSDictionary
                if let ss =  result["data"] as? NSArray {
                    for s in ss   {
                        var d:GraphData!
                        if let x =  s["x"] as? String {
                            if let y =  s["y"] as? Double {
                                d = GraphData(x: x,y: y)
                                
                                data.append(d)
                            }
                        }
                        
                        
                    }
                }
                
                
                completion(data: data)
            } else {
                completion(data: [])
            }
            }.resume()
        
    }
}