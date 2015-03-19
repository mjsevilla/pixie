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
    
    @IBOutlet weak var profPic: FBProfilePictureView!
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
    
    // handles hiding keyboard when user touches outside of keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // Facebook delegate methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
       
        println("User Logged In")
        println("This is where you perform a segue.")
//        performSegueWithIdentifier("presentSearch", sender: self)
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("User Name: \(user.name)")
        var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users";
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
        var session = NSURLSession.sharedSession();
        request.HTTPMethod = "POST"
        var err: NSError?
        var email = "\(user.username)@facebook.com"
        var reqText = ["name": "\(user.name)", "email": "\(user.name)", "password": "fake_pass"]
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err) // This Line fills the web service with required parameters.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var parseError : NSError?
                
                // parse data
                let unparsedArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                if let resp = unparsedArray as? NSDictionary {
                    //ewrijnkewjrewkjrnewkjrhnewkjrnjkewjknwrjnkewwknejrnkjrewnkjrjknerjnkrnjkerwnkjrnjkwernkjnkjwerkwjen
                    let defaults = NSUserDefaults.standardUserDefaults();
                    print("id is ")
                    println(resp["id"]! as Int);
                    defaults.setObject(resp["id"]! as Int, forKey: "PixieUserId")
                    NSUserDefaults.standardUserDefaults().synchronize();
                }
            }
        })
        task.resume()
        profPic.profileID = user.objectID
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