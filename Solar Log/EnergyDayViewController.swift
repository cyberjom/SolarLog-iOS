//
//  EnergyViewController.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/17/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class EnergyDayViewController: UIViewController ,CPTBarPlotDataSource,CPTBarPlotDelegate,CPTPlotSpaceDelegate {
    

    
    var items :[NSNumber] =  [1,1,1,1,2,5,10,15,20, 35, 18, 20, 50, 55,45,30,21,15,1,1,1,1,1,1,1]

    
    @IBOutlet var graphView: CPTGraphHostingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var CPDBarWidth:CGFloat = 0.25
        var CPDBarInitialX:CGFloat = 0.25
        
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.plotAreaFrame.masksToBorder = false
        graph.paddingBottom = 50.0
        graph.paddingLeft  = 50.0
        graph.paddingTop    = 50.0
        graph.paddingRight  = 50.0
        graph.backgroundColor = UIColor.whiteColor().CGColor
        
        var titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.blackColor()
        titleStyle.fontName = "Helvetica-Bold"
        titleStyle.fontSize = 16.0
        
        var title : NSString = "January 19, 2015"
        graph.title = title
        graph.titleTextStyle = titleStyle
        graph.titlePlotAreaFrameAnchor =  CPTRectAnchor.Top
        graph.titleDisplacement = CGPointMake(0.0, 40.0)
        
        var xMin : Double = 0
        var xMax : Double = Double(items.count) + 1
        var yMin : Double = 0
        var yMax : Double = maxItemsValue(items).doubleValue + 5
        
        //var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        //var xRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        //var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        
     
       // xRange.locationDouble.advancedBy(xMin)
//xRange.lengthDouble.distanceTo(xMax)
        
        //yRange.locationDouble.advancedBy(yMin)
       // yRange.lengthDouble.advancedBy(yMax)
      

        
        var aaplPlot = CPTBarPlot(frame:self.view.frame)
        aaplPlot.barsAreHorizontal = false
        
        var barLineStyle = CPTMutableLineStyle()
        
        barLineStyle.lineColor = CPTColor.lightGrayColor()
        barLineStyle.lineWidth = 1
        
        aaplPlot.dataSource = self
        aaplPlot.delegate = self
        //aaplPlot.barWidthScale = 1
        //aaplPlot.barOffsetScale = 1
        aaplPlot.lineStyle = barLineStyle
        
        graph.addPlot(aaplPlot)
        
        // Add plot space for horizontal bar charts
        var plotSpace =  graph.defaultPlotSpace as CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: xMin, length: xMax)
        plotSpace.yRange = CPTPlotRange(location: yMin, length: yMax)
        var axisSet = graph.axisSet as CPTXYAxisSet
        var x          = axisSet.xAxis
        x.axisLineStyle               = nil
        x.majorTickLineStyle          = nil
        x.minorTickLineStyle          = nil
        x.majorIntervalLength         = 5.0
        x.orthogonalPosition = 0.0
        x.title                       = "Hour of Day";
        x.titleLocation               = self.items.count/2
        x.titleOffset                 = 25.0
        
        
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor.redColor()
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 12.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1.0
        axisLineStyle.lineColor = CPTColor.redColor()
        
        // Define some custom labels for the data elements
        //x.labelRotation  = M_PI_4
        x.labelingPolicy = CPTAxisLabelingPolicy.None;
        x.axisLineStyle  = axisLineStyle
        //var customTickLocations = [0, 0, 0, 0 ,1 ,2 ,4,8,10,16,20,26,30,31];
        
        var labelLocation     = 0;
        var customLabels:NSMutableSet = NSMutableSet (capacity: items.count)
        var cnt = 0
        for cnt=0; cnt < items.count ; cnt++ {
            var newLabel = CPTAxisLabel(text: "\(cnt)" , textStyle: x.labelTextStyle)
            newLabel.tickLocation = cnt+1
            newLabel.offset       = x.labelOffset + x.majorTickLength;
            newLabel.rotation = CGFloat(M_PI_2)
            customLabels.addObject(newLabel)
        }
        
        x.axisLabels = customLabels;

        
        var y = axisSet.yAxis
        y.axisLineStyle               = nil;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.majorIntervalLength         = 10.0
        y.orthogonalPosition = 0.0
        y.title                       = "POWER (kW)"
        y.titleLocation               = yMax/2
        y.titleOffset                 = 35.0
      
        y.axisLineStyle  = axisLineStyle
        y.labelingPolicy    = .Automatic
        
        
        /*
        // Add legend
        var theLegend = CPTLegend(graph: graph)
        theLegend.fill            = CPTFill(color: CPTColor(genericGray: 0.15))
        theLegend.borderLineStyle = barLineStyle;
        theLegend.cornerRadius    = 10.0;
        var whiteTextStyle: CPTMutableTextStyle! = CPTMutableTextStyle() as CPTMutableTextStyle
        whiteTextStyle.color   = CPTColor.whiteColor()
        theLegend.textStyle    = whiteTextStyle;
        theLegend.numberOfRows = 1;
        
        graph.legend             = theLegend;
        graph.legendAnchor       = CPTRectAnchor.Top;
        //graph.legendDisplacement = CGPointMake( 0.0, self.titleSize * CPTFloat(-2.625) );
        */
        
        self.graphView.hostedGraph = graph

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
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex index: UInt) -> NSNumber! {

        switch (fieldEnum) {
        case 0:
            if (index < UInt(items.count)) {
              return index + 1
            }
            break;
            
        case 1:
            var ret = items[Int(index)]
             println("ret=\(ret)")
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
    
   
    
    func legendTitleForBarPlot(barPlot:CPTBarPlot,recordIndex index:Int) -> NSString{
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
