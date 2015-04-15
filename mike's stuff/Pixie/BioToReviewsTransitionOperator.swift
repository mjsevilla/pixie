//
//  BioToReviewsTransitionManager.swift
//  Matches
//
//  Created by Nicole on 2/22/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class BioToReviewsTransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
   
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
      let bioViewController = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!) as! BioViewController
      let reviewsViewController = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!) as! ReviewsViewController
      
      let bioView = bioViewController.view
      let reviewsView = reviewsViewController.view
      
      // add the both views to our view controller
      container.addSubview(bioView)
      container.addSubview(reviewsView)
      
      if (self.presenting) {
         reviewsView.transform = CGAffineTransformMakeTranslation(0, reviewsView.frame.height)
      }
      
      // get the duration of the animation
      let duration = self.transitionDuration(transitionContext)
      
      // perform the animation!
      UIView.animateWithDuration(0.25, delay: 0.0, options: nil, animations: {
         if (self.presenting) {
            reviewsView.transform = CGAffineTransformIdentity
         } else {
            reviewsView.transform = CGAffineTransformMakeTranslation(0, reviewsView.frame.height)
         }
         }, completion: { finished in
            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(true)
            
            if (!self.presenting) {
               UIApplication.sharedApplication().keyWindow?.addSubview(bioView)
            } else {
               UIApplication.sharedApplication().keyWindow?.addSubview(reviewsView)
            }
      })
      
   }
   
   // return how many seconds the transiton animation will take
   func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
      return 0.75
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

