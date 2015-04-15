//
//  MatchesToBioTransitionManager.swift
//  Matches
//
//  Created by Nicole on 2/21/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class MatchesToBioTransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
   
   private var presenting = true
   
   // MARK: UIViewControllerAnimatedTransitioning protocol methods
   
   // animate a change from one viewcontroller to another
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
      
      // get reference to our fromView, toView and the container view that we should perform the transition in
      let container = transitionContext.containerView()
      
      // create a tuple of our screens
      let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
      
      // assign references to our menu view controller and the 'bottom' view controller from the tuple
      // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
      let matchesViewController = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!) as! MatchesViewController
      let bioViewController = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!) as! BioViewController
      
      let matchesView = matchesViewController.view
      let bioView = bioViewController.view
      let imageFrame = (matchesViewController.currentCell?.profilePic)!.frame
      let profilePic = bioViewController.profilePic
      let infoView = bioViewController.userInfo
      
      var imageScale = CGAffineTransformConcat(CGAffineTransformMakeScale(imageFrame.size.width/profilePic.frame.size.width, imageFrame.size.height/profilePic.frame.size.height), CGAffineTransformMakeTranslation(0, profilePic.frame.size.width/16.0))
      var bioTranslate = CGAffineTransformMakeTranslation(0, bioView.frame.height)
      
      // add the both views to our view controller
      container.addSubview(matchesView)
      container.addSubview(bioView)
      
      if (presenting) {
         profilePic.transform = imageScale
         infoView.transform = CGAffineTransformMakeTranslation(0, infoView.frame.height)
      }
      
      // get the duration of the animation
      let duration = self.transitionDuration(transitionContext)
      
      // perform the animation!
      if (self.presenting) {
         UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: nil, animations: {
            profilePic.transform = CGAffineTransformIdentity
            infoView.transform = CGAffineTransformIdentity
            }, completion: { finished in
               // tell our transitionContext object that we've finished animating
               transitionContext.completeTransition(true)
               UIApplication.sharedApplication().keyWindow?.addSubview(bioView)
         })
      } else {
         UIView.animateWithDuration(0.10, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            infoView.transform = CGAffineTransformMakeTranslation(0, -5)
            
            }, completion: { finished in
               UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: nil, animations: {
                  infoView.transform = CGAffineTransformMakeTranslation(0, infoView.frame.height+5)
                  profilePic.transform = imageScale
                  
                  }, completion: { finished in
                     // tell our transitionContext object that we've finished animating
                     transitionContext.completeTransition(true)
                     UIApplication.sharedApplication().keyWindow?.addSubview(matchesView)
               })
         })
      }
      
   }
   
   // return how many seconds the transiton animation will take
   func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
      return 0.5
   }
   
   // MARK: UIViewControllerTransitioningDelegate protocol methods
   
   // return the animataor when presenting a viewcontroller
   // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
   func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
      // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
      self.presenting = true
      return self
   }
   
   // return the animator used when dismissing from a viewcontroller
   func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.presenting = false
      return self
   }
   
   
}
