//
//  NavigationCell.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/22/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class NavigationCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var countContainer: UIView!
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: "Syncopate-Regular", size: 16)
        titleLabel.textColor = UIColor.whiteColor()
        
        countLabel.font = UIFont(name: "Syncopate-Regular", size: 13)
        countLabel.textColor = UIColor.whiteColor()
        
        countContainer.backgroundColor = UIColor(red: 0.33, green: 0.62, blue: 0.94, alpha: 1.0)
        countContainer.layer.cornerRadius = 15
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        let countNotAvailable = countLabel.text == nil
        
        countContainer.hidden = countNotAvailable
        countLabel.hidden = countNotAvailable
        
    }
}