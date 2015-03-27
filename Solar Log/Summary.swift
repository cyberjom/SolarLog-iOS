//
//  Summary.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/19/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import Foundation
class Summary {
    var site_id:String = "Site"
    var datetime:NSDate = NSDate()
    
    var meteorologies:[Meteorology] = []
    var inverters:[Inverter]=[]
    var power:Double = 0.0
    var energy:Energy! = Energy()
    
}

class Energy {
    var today:Double = 0.0
    var revenuetoday:Double = 0.0
    var month:Double = 0.0
    var year:Double = 0.0
    var total:Double = 0.0

}