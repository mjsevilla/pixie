//
//  SignInViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/24/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
   @IBOutlet weak var emailField: UITextField!
   @IBOutlet weak var pwField: UITextField!
   @IBOutlet weak var inputBG: UIView!
   @IBOutlet weak var emailHeading: UIView!
   @IBOutlet weak var pwHeading: UIView!
   @IBOutlet weak var signInBtn: UIBarButtonItem!
   @IBOutlet weak var cancelBtn: UIBarButtonItem!
   @IBOutlet weak var wrongEmailPwLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      
      cancelBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
      signInBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
      
      inputBG.layer.shadowOpacity = 0.5
      inputBG.layer.shadowOffset = CGSize(width: 1, height: 3)
      inputBG.layer.cornerRadius = 8.0
      emailField.layer.cornerRadius = 8.0
      pwField.layer.cornerRadius = 8.0
      pwHeading.layer.cornerRadius = 8.0
      emailHeading.layer.cornerRadius = 8.0
      
      pwField.delegate = self
      emailField.delegate = self
      wrongEmailPwLabel.hidden = true
   }
   
   @IBAction func textFieldsArePopulated(sender: AnyObject) {
      signInBtn.enabled = count(emailField.text) > 0 &&
         count(pwField.text) > 0
   }
   
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      if textField == emailField && !emailField.text.isEmpty {
         self.pwField.becomeFirstResponder()
         return true
      }
      else if textField == pwField && !pwField.text.isEmpty {
         self.attemptSignIn(self)
         return true
      }
      return false
   }
   
   @IBAction func attemptSignIn(sender: AnyObject) {
      let email = emailField.text!
      let password = pwField.text!
      
      let defaults = NSUserDefaults.standardUserDefaults()
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users?email=\(email)&password=\(password)&facebook=\(0)&firstName=NULL&lastName=NULL"
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
         if let userId = json["userId"] as? String {
            if let first_name = json["first_name"] as? String {
               if let last_name = json["last_name"] as? String {
                  if let resp_email = json["email"] as? String {
                     if let resp_password = json["password"] as? String {
                        defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                        defaults.setObject(first_name, forKey: "PixieUserFirstName")
                        defaults.setObject(last_name, forKey: "PixieUserLastName")
                        defaults.setObject(resp_email, forKey: "PixieUserEmail")
                        defaults.setObject(resp_password, forKey: "PixieUserPassword")
                        let username = first_name + last_name + userId
                        PFUser.logInWithUsernameInBackground(username, password: resp_password) {
                            [unowned self] (user: PFUser?, error: NSError?) -> Void in
                            if user != nil {
                                println("Parse user successfully logged in")
                            } else {
                                println("Parse log in error: \(error!)")
                            }
                        }
                        NSUserDefaults.standardUserDefaults().synchronize()
                        println("signed in userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password)")
                        self.wrongEmailPwLabel.hidden = true
                        self.performSegueWithIdentifier("presentSearch", sender: self)
                     } else {
                        println("error password")
                     }
                  } else {
                     println("error email")
                  }
               } else {
                  println("error last_name")
               }
            } else {
               println("error first_name")
            }
         } else {
            wrongEmailPwLabel.hidden = false
            println("error userID")
         }
      } else {
         println("error json")
         wrongEmailPwLabel.hidden = false
      }
   }
   
   override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "presentSearch" {
         if let searchVC = segue.destinationViewController as? SearchViewController {
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
         }
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
   
}