//
//  BioViewController.swift
//  Matches
//
//  Created by Nicole on 2/17/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class BioViewController: UIViewController, UIGestureRecognizerDelegate {
   
   let profilePic: UIImageView = UIImageView()
   let userNameLabel: UILabel = UILabel()
   let userBioLabel: UILabel = UILabel()
   let userInfo: UIView = UIView()
   var widthMargin: CGFloat!
   var heightMargin: CGFloat!
   var itemHeight: CGFloat!
   
   var bioToReviewsTM = BioToReviewsTransitionOperator()
   
   override func loadView() {
      view = UIView(frame: UIScreen.mainScreen().bounds)
      view.backgroundColor = UIColor.clearColor()
      
      // Profile pic
      profilePic.setTranslatesAutoresizingMaskIntoConstraints(false)
      profilePic.userInteractionEnabled = true
      view.addSubview(profilePic)
      
      // View to hold user name and bio
      userInfo.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      
      // User name
      userNameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
      userNameLabel.textAlignment = .Left
      userNameLabel.adjustsFontSizeToFitWidth = true
      userNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.addSubview(userNameLabel)
      
      // User bio
      userBioLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 16)
      userBioLabel.textAlignment = .Left
      userBioLabel.numberOfLines = 0
      userBioLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
      userBioLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.addSubview(userBioLabel)
      
      view.addSubview(userInfo)
      
      var tap = UITapGestureRecognizer(target: self, action: "tapped:")
      tap.delegate = self
      profilePic.addGestureRecognizer(tap)
      
      //      var swipe = UISwipeGestureRecognizer(target: self, action: "swiped:")
      //      swipe.direction = UISwipeGestureRecognizerDirection.Up
      //      swipe.delegate = self
      //      view.addGestureRecognizer(swipe)
      
      let userInfoHeight = view.frame.height - 62 - view.frame.width
      let viewsDict = ["profilePic":profilePic, "userInfo":userInfo, "userName":userNameLabel, "userBio":userBioLabel]
      let metrics = ["profPicHeight":view.frame.width, "userInfoHeight":userInfoHeight]
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[profilePic]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[userInfo]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[userName]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[userBio]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-62-[profilePic(profPicHeight)]-0-[userInfo(userInfoHeight)]|", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[userName]-5-[userBio]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      view.layoutIfNeeded()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func tapped(recognizer: UITapGestureRecognizer) {
      self.performSegueWithIdentifier("unwindToMatches", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   func swiped(recognizer: UITapGestureRecognizer) {
      self.performSegueWithIdentifier("showReviews", sender: self)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "showReviews") {
         
         if let destinationVC = segue.destinationViewController as? ReviewsViewController {
            destinationVC.transitioningDelegate = self.bioToReviewsTM
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
         }
      }
   }
   
   @IBAction func unwindToBio(segue:UIStoryboardSegue) {}
}
