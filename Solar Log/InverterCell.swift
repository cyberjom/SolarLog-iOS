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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MpptCell
        var mppt = inverter.mppts[indexPath.row]
        cell.V.text  =  String(format: "%.0f V", mppt.V)
        
        if inverter.status == 0 {
            inverterImage.image = UIImage(named: "inverter0")
        }else if inverter.status == 1 {
            inverterImage.image = UIImage(named: "inverter1")
        }else if inverter.status == 2 {
            inverterImage.image = UIImage(named: "inverter2")
        }else if inverter.status == 3 {
            inverterImage.image = UIImage(named: "inverter3")
        }else if inverter.status == 4 {
            inverterImage.image = UIImage(named: "inverter4")
        }else{
            inverterImage.image = UIImage(named: "inverter")
            
        }
        return cell
    }
}
