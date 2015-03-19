//
//  RidePostedView.swift
//  Pixie
//
//  Created by Nicole on 3/18/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class RidePostedView: UIView {


   override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = UIColor.clearColor()
         
      var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
      blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.addSubview(blurEffectView)
      
      var ridePostedLabel = UILabel()
      ridePostedLabel.font = UIFont(name: "Syncopate-Regular", size: 40)
      ridePostedLabel.adjustsFontSizeToFitWidth = true
      ridePostedLabel.text = "Ride Posted!"
      ridePostedLabel.textAlignment = .Center
      ridePostedLabel.textColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0)
      ridePostedLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.addSubview(ridePostedLabel)
      
      let viewsDict = ["blurEffectView":blurEffectView, "ridePostedLabel":ridePostedLabel]
      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[ridePostedLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[ridePostedLabel]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.layoutIfNeeded()
   }
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

}
