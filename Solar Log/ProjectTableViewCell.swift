//
//  PlantTableViewCell.swift
//  Solar Log
//
//  Created by Noppadol Nuangjamnong on 3/24/2558 BE.
//  Copyright (c) 2558 InterSol. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    var project:Project!
    
    @IBOutlet var projectImage: UIImageView!
    
    @IBOutlet var projectName: UILabel!
    
    @IBOutlet var projectId: UILabel!
    
    @IBOutlet var capacity: UILabel!
    
    @IBOutlet var location: UILabel!
    
    
    @IBOutlet var province: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
