//
//  SummaryViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit
import AVFoundation

class SummaryViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    var refreshControl:UIRefreshControl!
    var timer:NSTimer?
    
    @IBOutlet weak var inverterCollection: UICollectionView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windspeed: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var power: UILabel!
    @IBOutlet weak var energytoday: UILabel!
    @IBOutlet weak var revenuetoday: UILabel!
    @IBOutlet weak var energythismonth: UILabel!
    @IBOutlet weak var energythisyear: UILabel!
    @IBOutlet weak var energytotal: UILabel!
    @IBOutlet weak var irradiance: UILabel!

    @IBOutlet weak var todayUnit: UILabel!
    @IBOutlet weak var monthUnit: UILabel!
    @IBOutlet weak var yearUnit: UILabel!
    @IBOutlet weak var totalUnit: UILabel!
    
    
    @IBOutlet weak var inverterCollection1: UICollectionView!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var temperature1: UILabel!
    @IBOutlet weak var humidity1: UILabel!
    @IBOutlet weak var windspeed1: UILabel!
    @IBOutlet weak var precipitation1: UILabel!
    @IBOutlet weak var power1: UILabel!
    @IBOutlet weak var energytoday1: UILabel!
    @IBOutlet weak var revenuetoday1: UILabel!
    @IBOutlet weak var energythismonth1: UILabel!
    @IBOutlet weak var energythisyear1: UILabel!
    @IBOutlet weak var energytotal1: UILabel!
    @IBOutlet weak var irradiance1: UILabel!
    @IBOutlet weak var todayUnit1: UILabel!
    @IBOutlet weak var monthUnit1: UILabel!
    @IBOutlet weak var yearUnit1: UILabel!
    @IBOutlet weak var totalUnit1: UILabel!
    
    @IBOutlet weak var inverterCollection2: UICollectionView!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var temperature2: UILabel!
    @IBOutlet weak var humidity2: UILabel!
    @IBOutlet weak var windspeed2: UILabel!
    @IBOutlet weak var precipitation2: UILabel!
    @IBOutlet weak var power2: UILabel!
    @IBOutlet weak var energytoday2: UILabel!
    @IBOutlet weak var revenuetoday2: UILabel!
    @IBOutlet weak var energythismonth2: UILabel!
    @IBOutlet weak var energythisyear2: UILabel!
    @IBOutlet weak var energytotal2: UILabel!
    @IBOutlet weak var irradiance2: UILabel!
    @IBOutlet weak var todayUnit2: UILabel!
    @IBOutlet weak var monthUnit2: UILabel!
    @IBOutlet weak var yearUnit2: UILabel!
    @IBOutlet weak var totalUnit2: UILabel!
    
    var summary:Summary! = Summary()
    var lastRevenue:Int = 0
    var coinSound  = AVAudioPlayer()
    var coinSoundThreshold : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateSetting:", name: "updateSetting", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changedProject:", name: "changedProject", object: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        coinSoundThreshold = defaults.integerForKey("\(MANAGER.CUR_PROJECT.id)")
        
        
        coinSound = self.setupAudioPlayerWithFile("coindrop", type:"mp3")
        self.inverterCollection?.registerNib(UINib(nibName: "InverterCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.inverterCollection1?.registerNib(UINib(nibName: "InverterCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.inverterCollection2?.registerNib(UINib(nibName: "InverterCelliPad", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        timer?.invalidate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "ScheduleCheck", userInfo: nil, repeats: true)
      //  updateData()

    }
    
    func updateSetting(notification:NSNotification){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        coinSoundThreshold = defaults.integerForKey("\(MANAGER.CUR_PROJECT.id)")
        println("updateSetting \(coinSoundThreshold)")
  
    }
    func changedProject(notification:NSNotification){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        coinSoundThreshold = defaults.integerForKey("\(MANAGER.CUR_PROJECT.id)")
        lastRevenue = 0
        timer?.invalidate()
        
       // timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "ScheduleCheck", userInfo: nil, repeats: true)
      //  updateData()
        
    }
    func refresh(sender:AnyObject){
        //TODO refresh data
        self.refreshControl?.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType:type as String)
        var url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        //4
        return audioPlayer!
    }
 
    func updateData(){
   
       // println("updateData")
        let fmt1 = NSDateFormatter()
        fmt1.dateFormat = "d MMM yyyy"
        let fmt2 = NSDateFormatter()
        fmt2.dateFormat = "HH:mm:ss"
        let now = NSDate()
        
        let formatter:NSNumberFormatter! = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.roundingMode = .RoundHalfUp
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        
        MANAGER.summary(){ result,hasUpdate in
            self.summary = result
            if(hasUpdate){
                var monthValue:String! = ""
                var monthUnit:String = ""
                if result.energy.month > 1000000000 {
                    monthValue = formatter.stringFromNumber(result.energy.month/1000000)
                    monthUnit="GWh"
                }else if result.energy.month > 1000000 {
                    
                    monthValue = formatter.stringFromNumber(result.energy.month/1000)
                    monthUnit="MWh"
                }else {
                    monthValue = formatter.stringFromNumber(result.energy.month)
                    monthUnit="kWh"
                }
                var yearValue:String! = ""
                var yearUnit:String = ""
                if result.energy.year > 1000000000 {
                    yearValue = formatter.stringFromNumber(result.energy.year/1000000)
                    yearUnit="GWh"
                }else if result.energy.year > 1000000 {
                    yearValue = formatter.stringFromNumber(result.energy.year/1000)
                    yearUnit="MWh"
                }else {
                    yearValue = formatter.stringFromNumber(result.energy.year)
                    yearUnit="kWh"
                }
                
                if( self.lastRevenue == 0 || self.lastRevenue > Int(result.energy.revenuetoday)) {
                    self.lastRevenue = Int(result.energy.revenuetoday)
                }

                dispatch_async(dispatch_get_main_queue(), {() in
                    
                    if Int(result.energy.revenuetoday) - self.lastRevenue >= self.coinSoundThreshold &&  self.coinSoundThreshold > 0 {
                        
                        if Int(result.energy.revenuetoday) > self.lastRevenue {
                            self.lastRevenue = Int(result.energy.revenuetoday)
                            self.coinSound.play()
                        }
                    }

                   
                    
                    
                    //iphone portrait
                    self.inverterCollection.reloadData()
                    self.date.text = fmt1.stringFromDate(result.datetime)
                    self.time.text = fmt2.stringFromDate(result.datetime)
                    self.revenuetoday.text = formatter.stringFromNumber(result.energy.revenuetoday)
               
                    self.power.text = formatter.stringFromNumber(result.power)
                    self.energytoday.text = formatter.stringFromNumber(result.energy.today)
                    
                    self.energytotal.text = formatter.stringFromNumber(result.energy.total)
                    self.energythismonth.text = monthValue
                    self.monthUnit.text = monthUnit
                    self.energythisyear.text = yearValue
                    self.yearUnit.text = yearUnit
                    
                    //iphone landscape
                    self.inverterCollection1?.reloadData()
                    self.date1?.text = fmt1.stringFromDate(result.datetime)
                    self.time1?.text = fmt2.stringFromDate(result.datetime)
                    
                    self.power1?.text = formatter.stringFromNumber(result.power)
                    self.energytoday1?.text = formatter.stringFromNumber(result.energy.today)
                    self.revenuetoday1?.text = formatter.stringFromNumber(result.energy.revenuetoday)
                    self.energytotal1?.text = formatter.stringFromNumber(result.energy.total)
                    self.energythismonth1?.text = monthValue
                    self.monthUnit1?.text = monthUnit
                    self.energythisyear1?.text = yearValue
                    self.yearUnit1?.text = yearUnit
                    
                    
                    //ipad
                    self.inverterCollection2?.reloadData()
                    self.date2?.text = fmt1.stringFromDate(result.datetime)
                    self.time2?.text = fmt2.stringFromDate(result.datetime)
                    
                    self.power2?.text = formatter.stringFromNumber(result.power)
                    self.energytoday2?.text = formatter.stringFromNumber(result.energy.today)
                    self.revenuetoday2?.text = formatter.stringFromNumber(result.energy.revenuetoday)
                    self.energytotal2?.text = formatter.stringFromNumber(result.energy.total)
                    self.energythismonth2?.text = monthValue
                    self.monthUnit2?.text = monthUnit
                    self.energythisyear2?.text = yearValue
                    self.yearUnit2?.text = yearUnit
                    
                    if !result.meteorologies.isEmpty {
                        //iphone portrait
                        self.temperature?.text = String(format: "%.0f°C", result.meteorologies[0].temperature)
                        self.humidity?.text = String(format: "%.0f%%", result.meteorologies[0].humidity)
                        self.windspeed?.text = String(format: "%.0fm/s", result.meteorologies[0].windspeed)
                        self.precipitation?.text = String(format: "%.0fmm", result.meteorologies[0].precipitation)
                        self.irradiance?.text = String(format: "%.0fw/m²", result.meteorologies[0].irradiance)
                        //iphone landscape
                        self.temperature1?.text = String(format: "%.0f°C", result.meteorologies[0].temperature)
                        self.humidity1?.text = String(format: "%.0f%%", result.meteorologies[0].humidity)
                        self.windspeed1?.text = String(format: "%.0fm/s", result.meteorologies[0].windspeed)
                        self.precipitation1?.text = String(format: "%.0fmm", result.meteorologies[0].precipitation)
                        self.irradiance1?.text = String(format: "%.0fw/m²", result.meteorologies[0].irradiance)
                        //ipad
                        self.temperature2?.text = String(format: "%.0f°C", result.meteorologies[0].temperature)
                        self.humidity2?.text = String(format: "%.0f%%", result.meteorologies[0].humidity)
                        self.windspeed2?.text = String(format: "%.0fm/s", result.meteorologies[0].windspeed)
                        self.precipitation2?.text = String(format: "%.0fmm", result.meteorologies[0].precipitation)
                        self.irradiance2?.text = String(format: "%.0fw/m²", result.meteorologies[0].irradiance)
                        
                        
                    }else{
                        //should hide component
                        
                    }
                    self.view.setNeedsDisplay()

                    
                })
                
            }
            
        }
        
    }
    
    func ScheduleCheck(){
        // println("ScheduleCheck")
        updateData();
    }
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return summary.inverters.count
    }
    
    //Cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var inverter = summary.inverters[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! InverterCell
        cell.collectView!.registerNib(UINib(nibName: "MpptCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        cell.inverter = inverter
        //iphone portrait
        cell.V.text  =  String(format: "%.0f V", inverter.V)
        cell.I.text = String(format: "%.1f A",inverter.I)

        cell.collectView.reloadData()
        /*
        //iphone landscape
        let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as InverterCell
        cell1.V.text  =  String(format: "%.0f V", inverter.V)
  
        cell1.I.text = String(format: "%.1f A",inverter.I)
        cell1.collectView1.reloadData()
        */
        return cell
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
