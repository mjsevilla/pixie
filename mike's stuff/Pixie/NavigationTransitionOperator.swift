//
//  NavigationTransitionOperator.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class NavigationTransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var snapshot : UIView!
    var isPresenting : Bool = true
    var presentingView : UIViewController!
    
    // returns the number of seconds that the animation takes
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning)
        -> NSTimeInterval {
            return 0.5
    }
    
    // return the animator when presenting a viewcontroller
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentNavigation(transitionContext)
        } else {
            dismissNavigation(transitionContext)
        }
    }
    
    // return the animator when dismissing a viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            presentingView = presented
            self.isPresenting = true
            return self
    }
    
    // returns which animator should be returned to dismiss
    func animationControllerForDismissedController(dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            self.isPresenting = false
            return self
    }
    
    // show navigation menu
    func presentNavigation(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        let size = toView.frame.size
        var offSetTransform = CGAffineTransformMakeTranslation(size.width - 120, 0)
        offSetTransform = CGAffineTransformScale(offSetTransform, 0.6, 0.6)
        
        snapshot = fromView.snapshotViewAfterScreenUpdates(true)
        
        // tap on the snapshot to dismiss menu back to previous view
        let aSelector : Selector = "dismissNav"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        self.snapshot.userInteractionEnabled = true
        self.snapshot.addGestureRecognizer(tapGesture)
        
        container.addSubview(toView)
        container.addSubview(snapshot)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.snapshot.transform = offSetTransform
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
        })
    }
    
    func dismissNav() {
        presentingView.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // hide navigation menu
    func dismissNavigation(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.snapshot.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                transitionContext.completeTransition(true)
                self.snapshot.removeFromSuperview()
        })
    }
}