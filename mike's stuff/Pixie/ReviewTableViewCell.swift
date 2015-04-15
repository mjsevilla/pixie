//
//  ReviewCell.swift
//  Matches
//
//  Created by Nicole on 3/2/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
   
   var colorImage: UIImageView!
   var commentLabel: UILabel!
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      self.backgroundColor = UIColor.clearColor()
      
      colorImage = UIImageView()
      colorImage.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.contentView.addSubview(colorImage)
      
      commentLabel = UILabel()
      commentLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 16)
      commentLabel.textColor = UIColor.whiteColor()
      commentLabel.numberOfLines = 0
      commentLabel.textAlignment = .Left
      commentLabel.lineBreakMode = .ByWordWrapping
      commentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.contentView.addSubview(commentLabel)
      
      let viewsDict = ["colorImage":colorImage, "commentLabel":commentLabel]
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[commentLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[commentLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-7-[colorImage]-7-[commentLabel]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.contentView.addConstraint(NSLayoutConstraint(item: colorImage!, attribute: .CenterY, relatedBy: .Equal, toItem: commentLabel!, attribute: .CenterY, multiplier: 1.0, constant: 0))
   }
   
}
