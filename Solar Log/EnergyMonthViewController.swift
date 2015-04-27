//
//  EnergyViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class EnergyMonthViewController: UIViewController ,CPTBarPlotDataSource,CPTBarPlotDelegate,CPTPlotSpaceDelegate {
    
    
    var items :[NSNumber] =  []

    
    @IBOutlet var graphView: CPTGraphHostingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewDidAppear(animated: Bool) {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        var CPDBarWidth:CGFloat = 0.25
        var CPDBarInitialX:CGFloat = 0.25
        
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.plotAreaFrame.masksToBorder = false
        graph.paddingBottom = 80.0
        graph.paddingLeft  = 50.0
        graph.paddingTop    = 50.0
        graph.paddingRight  = 50.0
        graph.backgroundColor = UIColor.whiteColor().CGColor
        
        var titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.blackColor()
        titleStyle.fontName = "Helvetica-Bold"
        titleStyle.fontSize = 16.0
        let fmt1 = NSDateFormatter()
        fmt1.dateFormat = "MMMM yyyy"
        
        var title : String! = fmt1.stringFromDate(NSDate())
        
        graph.title = title
        graph.titleTextStyle = titleStyle
        graph.titlePlotAreaFrameAnchor =  CPTRectAnchor.Top
        graph.titleDisplacement = CGPointMake(0.0, 40.0)
        
        var xMin : Double = 0
        var xMax : Double = Double(items.count) + 1
        var yMin : Double = 0
        var yMax : Double = maxItemsValue(items).doubleValue + 5
        
        
        
        
        var barPlot = CPTBarPlot(frame:self.view.frame)
        barPlot.barsAreHorizontal = false
        
        var barLineStyle = CPTMutableLineStyle()
        
        barLineStyle.lineColor = CPTColor.lightGrayColor()
        barLineStyle.lineWidth = 1
        barPlot.identifier = "Bar"
        barPlot.dataSource = self
        barPlot.delegate = self
        //barPlot.barWidthScale = 1
        //barPlot.barOffsetScale = 1
        barPlot.lineStyle = barLineStyle
        
        
        
        // Add plot space for horizontal bar charts
        var plotSpace =  graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: xMin, length: xMax)
        plotSpace.yRange = CPTPlotRange(location: yMin, length: yMax)
        
        graph.addPlot(barPlot, toPlotSpace: plotSpace)
        var axisSet = graph.axisSet as! CPTXYAxisSet
        
        var x  = axisSet.xAxis
        
        x.majorTickLineStyle  = nil
        x.minorTickLineStyle  = nil
        x.majorIntervalLength  = 5.0
        x.orthogonalPosition = 0.0
        x.title  = "Date";
        
        x.titleOffset = 60.0
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor.blackColor()
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 9.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1.0
        axisLineStyle.lineColor = CPTColor.blackColor()
        
        // Define some custom labels for the data elements
        //x.labelRotation  = M_PI_4
        x.labelingPolicy = CPTAxisLabelingPolicy.None;
        x.axisLineStyle  = axisLineStyle
        
        var y = axisSet.yAxis
        
        y.majorTickLineStyle  = nil;
        y.minorTickLineStyle = nil;
        y.majorIntervalLength = 10.0
        y.orthogonalPosition = 0.0
        y.title = "Energy (kWh)"
        y.axisConstraints = CPTConstraints.constraintWithLowerOffset(0)
        self.graphView.hostedGraph = graph
        y.titleOffset  = 35.0
        
        y.axisLineStyle  = axisLineStyle
        y.labelingPolicy = .Automatic
        MANAGER.energyMonth { (data) -> () in
            var i = 0
            var labelLocation  = 0;
            dispatch_async(dispatch_get_main_queue(), {() in
                var customLabels:NSMutableSet = NSMutableSet (capacity: self.items.count / 3)
                
                for  i = 0 ; i < data.count ; i++ {
                    var data = data[i]
                    
                    self.items.append(data.y as! Double)
                     if i % 3 == 0 {
                    var newLabel = CPTAxisLabel(text: "\(data.x as! String)" , textStyle: x.labelTextStyle)
                    var date:NSDate = fmt.dateFromString(data.x as! String)!
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components(.CalendarUnitDay , fromDate: date)
                    let currentDay = components.day
                    newLabel.tickLocation = currentDay
                    newLabel.offset = x.labelOffset + x.majorTickLength;
                    newLabel.rotation = CGFloat(M_PI_4)
                    customLabels.addObject(newLabel)
                    }
                    //println("tickLocation  = \(currentDay) --- \(data.x)")
                }
                x.axisLabels = customLabels as Set<NSObject>;
                
                var xMin : Double = 0
                var xMax : Double = Double(self.items.count + 1)
                var yMin : Double = 0
                var yMax : Double = self.maxItemsValue(self.items).doubleValue + 5
                
                
                // Add plot space for horizontal bar charts
                var plotSpace =  graph.defaultPlotSpace as! CPTXYPlotSpace
                plotSpace.xRange = CPTPlotRange(location: xMin, length: xMax)
                plotSpace.yRange = CPTPlotRange(location: yMin, length: yMax)
                
                plotSpace.scaleToFitPlots(graph.allPlots())
                var plot   = graph.plotWithIdentifier("Bar")
                plot.reloadData()
            })
            
        }
        
        
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
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(items.count)
    }

    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex index: UInt) -> AnyObject! {

        switch (fieldEnum) {
        case 0:
            if (index < UInt(items.count)) {
              return index + 1
            }
            break;
            
        case 1:
            var ret = items[Int(index)]

            return ret
        default:
            println("default")
            break;
            
        }
        
        return 1
        
        
    }
    
    
    func barFillForBarPlot(barPlot: CPTBarPlot!, recordIndex idx: UInt) -> CPTFill! {
        var areaColor:CPTColor!;
/*
        switch (idx)
        {
        case 0:
            areaColor = CPTColor.redColor()
            break;
            
        case 1:
            areaColor = CPTColor.yellowColor()
            break;
            
        case 2:
            areaColor = CPTColor.orangeColor()
            break;
            
        case 3:
            areaColor = CPTColor.greenColor()
            break;
            
        default:
            areaColor = CPTColor.purpleColor()
            break;
        }*/
        areaColor = CPTColor.redColor()
        var barFill:CPTFill = CPTFill(color: areaColor)
        //var fillGradient = CPTGradient(beginningColor: areaColor, endingColor: CPTColor.blackColor())
       // var barFill:CPTFill = CPTFill(gradient: fillGradient)
        return barFill;
    }
    
   
    
    func legendTitleForBarPlot(barPlot:CPTBarPlot!,recordIndex index:UInt) -> String{
        return "bar \(index)"
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

}
