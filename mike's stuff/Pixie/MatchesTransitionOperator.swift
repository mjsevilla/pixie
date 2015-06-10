//
//  MatchesTransitionOperator.swift
//  Pixie
//
//  Created by Nicole on 3/9/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MatchesTransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
   
   private var presenting = true
   
   // MARK: UIViewControllerAnimatedTransitioning protocol methods
   
   // animate a change from one viewcontroller to another
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
      
      // get reference to our fromView, toView and the container view that we should perform the transition in
      let container = transitionContext.containerView()
      
      let presentingVC = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!) as UIViewController
      let matchesVC = (self.presenting ? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! : transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!) as UIViewController
      
      let presentingView = presentingVC.view
      let matchesView = matchesVC.view
      
      // add the both views to our view controller
      container.addSubview(presentingView)
      container.addSubview(matchesView)
      
      if self.presenting {
         matchesView.transform = CGAffineTransformMakeTranslation(0, matchesView.frame.height)
      } else {
         presentingView.transform = CGAffineTransformMakeTranslation(0, -presentingView.frame.height)
      }
      
      // get the duration of the animation
      let duration = self.transitionDuration(transitionContext)
      
      // perform the animation!
      UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options:nil, animations: {
         if self.presenting {
            presentingView.transform = CGAffineTransformMakeTranslation(0, -presentingView.frame.height)
            matchesView.transform = CGAffineTransformIdentity
         } else {
            presentingView.transform = CGAffineTransformIdentity
            matchesView.transform = CGAffineTransformMakeTranslation(0, matchesView.frame.height)
         }
         }, completion: { finished in
            // tell our transitionContext object that we've finished animating
            
            transitionContext.completeTransition(true)
            if !self.presenting {
               //postRideView.removeFromSuperview()
               UIApplication.sharedApplication().keyWindow?.addSubview(presentingView)
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
