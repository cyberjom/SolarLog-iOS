//
//  PlantTableViewCell.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/24/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {

    var site:Site!
    
    @IBOutlet var siteImage: UIImageView!
    
    @IBOutlet var siteName: UILabel!
    
    @IBOutlet var siteId: UILabel!
    
    @IBOutlet var size: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
