//
//  HomeToPostRideTransitionManager.swift
//  PostRide
//
//  Created by God.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class PostRideTransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
   
   private var presenting = true
   
   // MARK: UIViewControllerAnimatedTransitioning protocol methods
   
   // animate a change from one viewcontroller to another
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
      
      // get reference to our fromView, toView and the container view that we should perform the transition in
      let container = transitionContext.containerView()
      
      let searchVC = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!) as! SearchViewController
      let postRideVC = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!) as! PostRideViewController
      
      let searchView = searchVC.view
      let postRideView = postRideVC.view
      
      // add the both views to our view controller
      container.addSubview(searchView)
      container.addSubview(postRideView)
      
      if self.presenting {
         postRideView.transform = CGAffineTransformMakeTranslation(postRideView.frame.width, 0)
      }
      
      // get the duration of the animation
      let duration = self.transitionDuration(transitionContext)
      
      // perform the animation!
      UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options:nil, animations: {
         if self.presenting {
            postRideView.transform = CGAffineTransformIdentity
            searchVC.pixieLabel.hidden = true
            searchVC.searchBar.hidden = true
            searchVC.toolBar.hidden = true
         } else {
            postRideView.transform = CGAffineTransformMakeTranslation(postRideView.frame.width, 0)
            searchVC.pixieLabel.hidden = false
            searchVC.searchBar.hidden = false
            searchVC.toolBar.hidden = false
         }
         }, completion: { finished in
            // tell our transitionContext object that we've finished animating
            
            transitionContext.completeTransition(true)
            
            UIApplication.sharedApplication().keyWindow?.addSubview(searchView)
            if self.presenting {
               UIApplication.sharedApplication().keyWindow?.addSubview(postRideView)
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
