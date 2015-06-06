//
//  ACTableViewCell.swift
//  Pixie
//
//  Created by Nicole on 5/28/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation

class ACTableViewCell: UITableViewCell {
   
   var placeLabel: UILabel!
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
//      self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.75)
      
      placeLabel = UILabel()
      placeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
      placeLabel.textColor = UIColor.blackColor()
      placeLabel.numberOfLines = 0
      placeLabel.textAlignment = .Left
      placeLabel.lineBreakMode = .ByWordWrapping
      placeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.contentView.addSubview(placeLabel)
      
      let viewsDict = ["placeLabel":placeLabel]
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[placeLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[placeLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
   }
   
}