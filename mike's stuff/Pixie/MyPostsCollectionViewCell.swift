//
//  MyRidesCollectionViewCell.swift
//  Pixie
//
//  Created by Nicole on 3/19/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MyPostsCollectionViewCell: UICollectionViewCell {
   
   var locationLabel: UILabel!
   var dateTimeLabel: UILabel!
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.backgroundColor = UIColor.whiteColor()
      self.layer.shadowColor = UIColor.grayColor().CGColor
      self.layer.shadowOffset = CGSizeMake(0, 2.0)
      self.layer.shadowRadius = 1.0
      self.layer.shadowOpacity = 0.3
      self.layer.masksToBounds = false
      self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath

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
      
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[location]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[dateTime]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[location]-5-[dateTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.layoutIfNeeded()
      
   }
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
}
