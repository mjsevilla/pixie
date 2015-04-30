//
//  MessageCell.swift
//  Pixie
//
//  Created by Mike Sevilla on 4/29/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        nameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        nameLabel.textColor = UIColor.blackColor()
        lastMessageLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 14)
        lastMessageLabel.textColor = UIColor(red: 0.551, green: 0.551, blue: 0.551, alpha: 1.0)
        timestampLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        timestampLabel.textColor = UIColor.blackColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
}