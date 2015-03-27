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

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
class LogManager{
    var ACCESS_TOKEN:String = ""
    var CUR_URL:String = URLS[0]
    var CUR_SITE:Site = Site(id: 101, name: "Demo 1")
    var IS_DEMO:Bool = true
    
    func login(user:String,passwd:String,completion: (success:Bool,result : User) ->()){
        
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/login?user=\(user)&passwd=\(passwd)"
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
                var result = jsonResult as NSDictionary
                if let status =  result["status"] as? String {
                    if status == "success" {
                        if let t =  result["access_token"] as? String {
                            self.ACCESS_TOKEN = t
                        }
                        if let u =  result["user"] as? NSDictionary {
                            if let id =  result["id"] as? String {
                                if let id =  result["id"] as? String {
                                    var user = User(id: id)
                                    if let name =  result["name"] as? String {
                                        user.name = name
                                    }
                                    completion(success: true, result: user)
                                    return
                                }
                            }
                        }
                        
                    }
                   
                }
                
               completion(success: false, result:  User(id: ""))
            } else {
                completion(success: false, result:  User(id: ""))
            }
            }.resume()
    }
    
    func sites(completion: (result : [Site]) ->()){
        var ts = NSDate().timeIntervalSince1970
        let url = "\(CUR_URL)/sites?access_token=\(ACCESS_TOKEN)"
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
                var sites:[Site] = []
                if let ss =  jsonResult as? NSArray {
                    for s in ss   {
                        var site:Site!
                        if let id =  s["id"] as? Int {
                            if let name =  s["name"] as? String {
                                site = Site(id: id, name: name)
                                sites.append(site)
                            }
                        }
                        
                        
                    }
                }
                
                completion(result: sites)
            } else {
                // couldn't load JSON, look at error
            }
            }.resume()

    }
    
    func summary(completion: (result : Summary) ->()){
        var ts = NSDate().timeIntervalSince1970
        println("site=\(CUR_SITE.id)")
        let url = "\(CUR_URL)/meter_reads/json/\(CUR_SITE.id)?access_token=\(ACCESS_TOKEN)&ts=\(ts)"
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
                //println(jsonResult)
                var result = jsonResult as NSDictionary
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
                completion(result: summary)
            } else {
                // couldn't load JSON, look at error
            }
            }.resume()
        
    }
    
    //

}