//
//  PowerGaugeViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 4/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class PowerGaugeViewController: UIViewController {

    @IBOutlet var gaugeView: WMGaugeView!
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer?.invalidate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "ScheduleCheck", userInfo: nil, repeats: true)
       // gaugeView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        gaugeView.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if MANAGER.CUR_PROJECT.capacity == 0 {
            return
        }
        var max = Float(round(Float(MANAGER.CUR_PROJECT.capacity) / 1000.0))
        println("capacity= \(MANAGER.CUR_PROJECT.capacity) max= \(max)")

        gaugeView.scaleDivisionColor = UIColor.whiteColor()
        gaugeView.rangeLabelsFontColor  = UIColor.redColor()
        gaugeView.scaleSubDivisionColor = UIColor.whiteColor()
        gaugeView.showRangeLabels = true
        gaugeView.scaleDivisions = CGFloat(max)
        gaugeView.scaleSubdivisions = 1;
        
        gaugeView.scaleStartAngle = 30;
        gaugeView.scaleEndAngle = 280;
        gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleGradient;
        gaugeView.showScaleShadow = true;
       
        //gaugeView.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter;
       // gaugeView.scaleSubdivisionsWidth = 0.002;
       // gaugeView.scaleSubdivisionsLength = 0.04;
        //gaugeView.scaleDivisionsWidth = 0.007;
        //gaugeView.scaleDivisionsLength = 0.07;
        //gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
        //gaugeView.needleWidth = 0.012;
       // gaugeView.needleHeight = 0.4;
        //gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
        //gaugeView.needleScrewRadius = 0.05;
        /*
        _gaugeView.rangeValues = @[ @50,                  @90,                @130,               @240.0              ];
        _gaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
        _gaugeView.rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
*/
        gaugeView.maxValue = max
    
        gaugeView.showUnitOfMeasurement = true;
        gaugeView.unitOfMeasurement = "kW";
        var data = MANAGER.powers[MANAGER.powers.count - 1]
        
        gaugeView.setValue( data.y as! Float, animated: true)
    }
    
    func roundUp(value: Int, divisor: Int) -> Int {
        let rem = value % divisor
        return rem == 0 ? value : value + divisor - rem
    }
    func ScheduleCheck(){

        if !MANAGER.powers.isEmpty {
            var data = MANAGER.powers[MANAGER.powers.count - 1]
           
            gaugeView.setValue( data.y as! Float, animated: true)
        }
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
