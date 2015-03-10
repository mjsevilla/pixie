//
//  ProfileViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 3/9/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var navTransitionOperator = NavigationTransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as NavigationViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.navTransitionOperator
            toViewController.presentingView = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}