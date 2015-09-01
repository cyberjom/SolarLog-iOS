//
//  Inverter.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/22/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import Foundation
/*
Status Code
0 = No Data
1 = Synced (Connected)
2 = DC Low
3 = Grid Bad
4 = Delay
5 = Connecting
6 = Fault



*/
class Inverter {
    var id:Int = 0
    var mppts:[Mppt] = []
    var status:Double = 0.0
    var V:Double = 0.0
    var I:Double = 0.0
    
}

class Mppt{
    var id:Int = 0
    var V:Double = 0.0
    var strings:[MpptString] = []
}

class MpptString {
    var id:Int = 0
    var I:Double = 0.0
    var T:Double = 0.0
}