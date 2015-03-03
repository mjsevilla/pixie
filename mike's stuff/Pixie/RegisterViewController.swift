//
//  RegisterViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/26/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView: FBLoginView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    @IBOutlet weak var inputBG: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var nameHeading: UIView!
    @IBOutlet weak var emailHeading: UIView!
    @IBOutlet weak var pwHeading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        cancelBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
        signInBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
        
        inputBG.layer.shadowOpacity = 0.5
        inputBG.layer.shadowOffset = CGSize(width: 1, height: 3)
        inputBG.layer.cornerRadius = 8.0
        
        nameField.layer.cornerRadius = 8.0
        emailField.layer.cornerRadius = 8.0
        pwField.layer.cornerRadius = 8.0
        nameHeading.layer.cornerRadius = 8.0
        emailHeading.layer.cornerRadius = 8.0
        pwHeading.layer.cornerRadius = 8.0
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // Facebook delegate methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
        performSegueWithIdentifier("presentSearch", sender: self)
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("User Name: \(user.name)")
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentSearch" {
            if let searchVC = segue.destinationViewController as? SearchViewController {
                
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