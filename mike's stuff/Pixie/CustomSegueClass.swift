//
//  CustomSegueClass.swift
//  Pixie
//
//  Created by Mike Sevilla on 5/10/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class CustomSegueClass: UIStoryboardSegue {
    override func perform() {
        var sourceViewController: UIViewController = self.sourceViewController as! UIViewController
        var destinationViewController: UIViewController = self.destinationViewController as! UIViewController
        sourceViewController.view.addSubview(destinationViewController.view)
        destinationViewController.view.removeFromSuperview()
        
        // Force presentViewController() into a different runloop.
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
        }
    }
}