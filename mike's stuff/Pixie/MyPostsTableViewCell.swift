//
//  MyPostsTableViewCell.swift
//  Pixie
//
//  Created by Nicole on 4/26/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {
   
   var locationLabel: UILabel!
   var dateTimeLabel: UILabel!
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      self.backgroundColor = UIColor.clearColor()
      
      // Location
      locationLabel = UILabel()
      locationLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
      locationLabel.textAlignment = .Left
      locationLabel.adjustsFontSizeToFitWidth = true
      locationLabel.lineBreakMode = .ByClipping
      locationLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(locationLabel)
      
      // Date and time
      dateTimeLabel = UILabel()
      dateTimeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
      dateTimeLabel.textAlignment = .Left
      dateTimeLabel.adjustsFontSizeToFitWidth = true
      dateTimeLabel.lineBreakMode = .ByClipping
      dateTimeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(dateTimeLabel)
      
      
      let viewsDict = ["location":locationLabel, "dateTime":dateTimeLabel]
      
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[location]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[dateTime]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[location]-5-[dateTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
   }
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
