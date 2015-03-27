//
//  InverterCell.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/22/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class InverterCell: UICollectionViewCell ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var inverterImage: UIImageView!
    @IBOutlet var V: UILabel!
    @IBOutlet var I: UILabel!
    @IBOutlet var collectView: UICollectionView!
    

    var inverter:Inverter! = Inverter()
    

    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inverter.mppts.count
    }
    
    //Cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MpptCell
        var mppt = inverter.mppts[indexPath.row]
        cell.V.text  =  String(format: "%.0f V", mppt.V)
        return cell
    }
}
