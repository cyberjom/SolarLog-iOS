//
//  Inverter.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/22/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import Foundation
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