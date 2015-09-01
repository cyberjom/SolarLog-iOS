//
//  PowerViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 4/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class PowerViewController: UIViewController , CPTPlotDataSource {
    
    
    @IBOutlet var graphView: CPTGraphHostingView!
    let kMaxDataPoints = 20
    var items :[NSNumber] =  []
    var timer:NSTimer?
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer?.invalidate()
       
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "ScheduleCheck", userInfo: nil, repeats: true)
        var i = 0
        items = []
        for i = 0 ; i < MANAGER.powers.count ; i++ {
            var data = MANAGER.powers[i]
            items.append(data.y as! Double)
        }
        currentIndex = items.count
        //println("items=\(items)")
        //Init graphDouble
        var CPDBarWidth:CGFloat = 0.25
        var CPDBarInitialX:CGFloat = 0.25
        
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.plotAreaFrame!.masksToBorder = false
        graph.paddingBottom = 50.0
        graph.paddingLeft  = 50.0
        graph.paddingTop    = 50.0
        graph.paddingRight  = 50.0
        graph.backgroundColor = UIColor.whiteColor().CGColor
        
        var titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.blackColor()
        titleStyle.fontName = "Helvetica-Bold"
        titleStyle.fontSize = 16.0
        
        var title : String = "POWER"
        graph.title = title
        graph.titleTextStyle = titleStyle
        graph.titlePlotAreaFrameAnchor =  CPTRectAnchor.Top
        graph.titleDisplacement = CGPointMake(0.0, 40.0)
        
        var xMin : Double = 0
        var xMax : Double = Double(kMaxDataPoints - 2)
        var yMin : Double = 0
        var yMax : Double = maxItemsValue(items).doubleValue + 5
        
        
        var linePlot = CPTScatterPlot(frame:self.view.frame)
        linePlot.dataSource = self
        linePlot.delegate = self
        linePlot.identifier = "Power"
        
        
        // Add plot space for horizontal bar charts
        var plotSpace =  graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: xMin, length: xMax)
        plotSpace.yRange = CPTPlotRange(location: yMin, length: yMax)
        
        graph.addPlot(linePlot, toPlotSpace: plotSpace)
        
        // 4 - Create styles and symbols
        var lineStyle:CPTMutableLineStyle = linePlot.dataLineStyle!.mutableCopy() as! CPTMutableLineStyle
        
        lineStyle.lineWidth = 2.5;
        lineStyle.lineColor = CPTColor.redColor();
        linePlot.dataLineStyle = lineStyle;
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1.0
        axisLineStyle.lineColor = CPTColor.blackColor()
        
        
        var axisSet = graph.axisSet as! CPTXYAxisSet
        var x = axisSet.xAxis
        
        x!.majorTickLineStyle  = nil
        x!.minorTickLineStyle = nil
        x!.majorIntervalLength  = 5.0
        x!.orthogonalPosition = 0.0
        x!.title  = "Time";
        // x.titleLocation  = kMaxDataPoints / 2
        x!.titleOffset  = 25.0
        x!.labelingPolicy    = .Automatic
        
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor.blackColor()
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 9.0
        
        
        // Define some custom labels for the data elements
        //x.labelRotation  = CGFloat(M_PI_4)
        
        x!.axisLineStyle  = axisLineStyle
        
        
        var y = axisSet.yAxis
        
        y!.majorTickLineStyle  = nil;
        y!.minorTickLineStyle  = nil;
        y!.majorIntervalLength   = 10.0
        y!.orthogonalPosition = 0.0
        y!.title = "POWER (kW)"
        y!.titleLocation = yMax/2
        y!.titleOffset   = 35.0
        y!.axisConstraints = CPTConstraints.constraintWithLowerOffset(0)
        
        y!.axisLineStyle  = axisLineStyle
        y!.labelingPolicy = .Automatic
        
        
        
        self.graphView.hostedGraph = graph
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
  
   
    
    func maxItemsValue(items :[NSNumber])-> NSNumber{
        var max : NSNumber=0
        
        for item in items{
            if item.floatValue > max.floatValue {
                max = item
            }
        }
        
        return max
    }
    func ScheduleCheck(){
        if MANAGER.powers.isEmpty {
            return
        }
        dispatch_async(dispatch_get_main_queue(), {() in
            var graph:CPTGraph = self.graphView.hostedGraph!
            var plot:CPTPlot = graph.plotWithIdentifier("Power")!
            var i = 0
            while (self.items.count >= self.kMaxDataPoints ) {
                self.items.removeAtIndex(0)
                plot.deleteDataInIndexRange(NSMakeRange(0, 1))
            }
            
            
            // Add plot space for horizontal bar charts
            var plotSpace =  graph.defaultPlotSpace as! CPTXYPlotSpace
            //plotSpace.scaleToFitPlots(graph.allPlots())
            var location  = (self.currentIndex >= self.kMaxDataPoints ? self.currentIndex - self.kMaxDataPoints + 2 : 0);
            var newPlotRange =  CPTPlotRange(location: location, length:  self.kMaxDataPoints - 2)
            let duration = CGFloat(1.5)
            
            // println("range \(location) \(items.count) ")
            let curve = CPTAnimationCurve.ExponentialInOut
            CPTAnimation.animate(plotSpace, property: "xRange", fromPlotRange: plotSpace.xRange, toPlotRange: newPlotRange, duration: CGFloat(1.5))
            
            self.currentIndex++
            //for i = items.count ; i < MANAGER.powers.count ; i++ {
            var data = MANAGER.powers[MANAGER.powers.count-1]
            self.items.append(data.y as! Double)
            plot.insertDataAtIndex(UInt(self.items.count - 1 ), numberOfRecords: UInt(1))
            
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
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return UInt(items.count)
    }
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex index: UInt) -> AnyObject? {
        switch (fieldEnum) {
        case 0:
           // println("index=\(index)")
            return (Int(index) + currentIndex) - items.count
            
        case 1:
            var ret = items[Int(index)]
            //println("ret=\(ret)")
            return ret
        default:
            println("default")
            break;
            
        }
        
        return 1
    }
    

}
