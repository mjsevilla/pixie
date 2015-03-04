//
//  SignInViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/24/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var inputBG: UIView!
    @IBOutlet weak var emailHeading: UIView!
    @IBOutlet weak var pwHeading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        inputBG.layer.shadowOpacity = 0.5
        inputBG.layer.shadowOffset = CGSize(width: 1, height: 3)
        inputBG.layer.cornerRadius = 8.0
        emailField.layer.cornerRadius = 8.0
        pwField.layer.cornerRadius = 8.0
        pwHeading.layer.cornerRadius = 8.0
        emailHeading.layer.cornerRadius = 8.0
    }
    
    // handles hiding keyboard when user touches outside of keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentSearch" {
            if let searchVC = segue.destinationViewController as?
                SearchViewController {
                
            }
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