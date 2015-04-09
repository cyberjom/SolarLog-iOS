//
//  Site.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/24/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import Foundation
class Project {
    var id:Int
    var name:String
    var location:String = ""
    var province:String = ""
    var size:Int = 0
    
    init(id:Int,name:String){
        self.id = id
        self.name = name
    }
    
}