//
//  MatchCell.swift
//  Matches
//
//  Created by Nicole on 2/16/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
   
   var profilePic: UIImageView!
   var userNameLabel: UILabel!
   var seekOfferLabel: UILabel!
   var locationLabel: UILabel!
   var dateTimeLabel: UILabel!
   var lineImage: UIImageView!
   var messageIcon: SenderButton!
   var starIcon: UIButton!
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.layer.borderColor = UIColor.grayColor().CGColor
      
      // Profile picture
      profilePic = UIImageView()
      profilePic.contentMode = UIViewContentMode.ScaleToFill
      profilePic.userInteractionEnabled = true
      profilePic.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(profilePic)
      
      // User name
      userNameLabel = UILabel()
      userNameLabel.textAlignment = .Center
      userNameLabel.adjustsFontSizeToFitWidth = true
      userNameLabel.lineBreakMode = .ByClipping
      userNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(userNameLabel)
      
      // Seeking/Offering
      seekOfferLabel = UILabel()
      seekOfferLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 14)
      seekOfferLabel.textAlignment = .Left
      seekOfferLabel.adjustsFontSizeToFitWidth = true
      seekOfferLabel.lineBreakMode = .ByClipping
      seekOfferLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(seekOfferLabel)
      
      // Location
      locationLabel = UILabel()
      locationLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 14)
      locationLabel.textAlignment = .Left
      locationLabel.adjustsFontSizeToFitWidth = true
      locationLabel.lineBreakMode = .ByClipping
      locationLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(locationLabel)
      
      // Date and time
      dateTimeLabel = UILabel()
      dateTimeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 14)
      dateTimeLabel.textAlignment = .Left
      dateTimeLabel.adjustsFontSizeToFitWidth = true
      dateTimeLabel.lineBreakMode = .ByClipping
      dateTimeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(dateTimeLabel)
      
      messageIcon = SenderButton()
      messageIcon.setImage(UIImage(named: "chat-bubble32.png")!, forState: .Normal)
      messageIcon.backgroundColor = UIColor.clearColor()
      messageIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(messageIcon)
      
      starIcon = UIButton()
      starIcon.setImage(UIImage(named: "star.png")!, forState: .Normal)
      starIcon.backgroundColor = UIColor.clearColor()
      starIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(starIcon)
      
      // Gradient background
      let gradient = CAGradientLayer()
      gradient.frame = bounds
      gradient.colors = [UIColor.whiteColor().CGColor, UIColor(red:0.69, green:0.97, blue:1.0, alpha:1.0).CGColor, UIColor(red:0.68, green:0.91, blue:0.98, alpha:1.0).CGColor]
      let bView = UIView()
      bView.layer.insertSublayer(gradient, atIndex: 0)
      backgroundView = bView
      
      // Horizontal line and arrow
      UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
      let cntx = UIGraphicsGetCurrentContext()
      CGContextSetStrokeColorWithColor(cntx, UIColor.blackColor().CGColor)
      CGContextSetLineWidth(cntx, 0.35)
      CGContextMoveToPoint(cntx, 0, 0)
      CGContextAddLineToPoint(cntx, frame.size.width, 0)
      CGContextStrokePath(cntx)
      lineImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 1))
      lineImage.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      lineImage.setTranslatesAutoresizingMaskIntoConstraints(false)
      contentView.addSubview(lineImage)
      
      
      let viewsDict = ["profilePic":profilePic, "userName":userNameLabel, "seekOffer":seekOfferLabel, "location":locationLabel, "dateTime":dateTimeLabel, "line":lineImage, "message":messageIcon, "star":starIcon]
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[profilePic]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[userName]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[line]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[seekOffer]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[location]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[dateTime]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[message]-1-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[profilePic]-3-[userName]-5-[seekOffer]-0-[location]-0-[dateTime]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userName]-1-[line]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      contentView.addConstraint(NSLayoutConstraint(item: messageIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: profilePic, attribute: .CenterX, multiplier: 1.0, constant: 0))
      contentView.addConstraint(NSLayoutConstraint(item: starIcon, attribute: NSLayoutAttribute.RightMargin, relatedBy: .Equal, toItem: profilePic, attribute: .RightMargin, multiplier: 1.0, constant: -1))
      contentView.addConstraint(NSLayoutConstraint(item: starIcon, attribute: NSLayoutAttribute.TopMargin, relatedBy: .Equal, toItem: profilePic, attribute: .TopMargin, multiplier: 1.0, constant: 1))
      contentView.addConstraint(NSLayoutConstraint(item: profilePic, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: profilePic, attribute: .Width, multiplier: 1.0, constant: 0))
      
      self.layoutIfNeeded()
   }
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
}
