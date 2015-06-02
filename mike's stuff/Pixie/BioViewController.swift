//
//  BioViewController.swift
//  Matches
//
//  Created by Nicole on 2/17/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class BioViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
   
   var scrollView: UIScrollView = UIScrollView()
   var containerView: UIView = UIView()
   
   let profilePic: UIImageView = UIImageView()
   let userInfo: UIView = UIView()
   let userNameLabel: UILabel = UILabel()
   let userBio: UITextView = UITextView()
   
   var imageWidth: CGFloat!
   var imageHeight: CGFloat!
   
   var bioToReviewsTM = BioToReviewsTransitionOperator()
   var navTransitionOperator = NavigationTransitionOperator()
   
   override func loadView() {
      super.loadView()
      view.backgroundColor = UIColor.clearColor()
      
      let containerSize = CGSize(width: view.frame.width, height: view.frame.height)
      containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
      scrollView.addSubview(containerView)
      
      scrollView.contentSize = containerSize;
      scrollView.backgroundColor = UIColor.whiteColor()
      scrollView.scrollEnabled = true
      scrollView.scrollsToTop = true
      scrollView.showsVerticalScrollIndicator = false
      scrollView.delegate = self
      scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(scrollView)
      
      // Profile pic
      profilePic.setTranslatesAutoresizingMaskIntoConstraints(false)
      profilePic.userInteractionEnabled = true
      containerView.addSubview(profilePic)
      
      // View to hold user name and bio
      userInfo.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      containerView.addSubview(userInfo)
      
      // User name
      userNameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
      userNameLabel.textAlignment = .Left
      userNameLabel.adjustsFontSizeToFitWidth = true
      userNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.addSubview(userNameLabel)
      
      // User bio
      userBio.font = UIFont(name: "HelveticaNeue-UltraLight", size: 16)
      userBio.textAlignment = .Left
      userBio.editable = false
      userBio.textContainerInset = UIEdgeInsetsZero
      userBio.contentInset = UIEdgeInsetsZero
      userBio.scrollEnabled = false
      userBio.setTranslatesAutoresizingMaskIntoConstraints(false)
      userInfo.addSubview(userBio)
      
      var tap = UITapGestureRecognizer(target: self, action: "tapped:")
      tap.delegate = self
      profilePic.addGestureRecognizer(tap)
      
      //      var swipe = UISwipeGestureRecognizer(target: self, action: "swiped:")
      //      swipe.direction = UISwipeGestureRecognizerDirection.Up
      //      swipe.delegate = self
      //      view.addGestureRecognizer(swipe)
      
      let viewsDict = ["scrollView":scrollView, "containerView":containerView, "profilePic":profilePic, "userInfo":userInfo, "userName":userNameLabel, "userBio":userBio]
      let metrics = ["profPicSize":view.frame.width]
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[scrollView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[profilePic(profPicSize)]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[userInfo]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[userName]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[userBio]-12-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[profilePic(profPicSize)]-0-[userInfo]|", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
      userInfo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[userName]-8-[userBio]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      view.layoutIfNeeded()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      imageHeight = profilePic.frame.height
      imageWidth = profilePic.frame.width
      userBio.sizeToFit()
      view.layoutIfNeeded()
      
      let addedHeight = (8 + userNameLabel.frame.height + 8 + userBio.frame.height + 8) - userInfo.frame.height + 64
      let containerSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + addedHeight)
      containerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize)
      scrollView.contentSize = containerSize;
      
      view.layoutIfNeeded()
   }
   
   func tapped(recognizer: UITapGestureRecognizer) {
      scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
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
      } else if segue.identifier == "presentNav" {
         let toViewController = segue.destinationViewController as! NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
   }
   
   func scrollViewDidScroll(scrollView: UIScrollView) {
      let yPos = -scrollView.contentOffset.y
      if (yPos > 0) {
         var imgRect = self.profilePic.frame
         imgRect.origin.x = scrollView.contentOffset.y/2
         imgRect.origin.y = scrollView.contentOffset.y
         imgRect.size.width = imageWidth + yPos
         imgRect.size.height = imageHeight + yPos
         self.profilePic.frame = imgRect
      }
   }
   
   @IBAction func unwindToBio(segue:UIStoryboardSegue) {}
}
