//
//  SignInViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/24/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, FBLoginViewDelegate {
   @IBOutlet weak var emailField: UITextField!
   @IBOutlet weak var pwField: UITextField!
   @IBOutlet weak var inputBG: UIView!
   @IBOutlet weak var emailHeading: UIView!
   @IBOutlet weak var pwHeading: UIView!
   @IBOutlet weak var signInBtn: UIBarButtonItem!
   @IBOutlet weak var cancelBtn: UIBarButtonItem!
   @IBOutlet weak var wrongEmailPwLabel: UILabel!
   @IBOutlet var fbLoginView: FBLoginView!
   var user: PFUser?
   let defaults = NSUserDefaults.standardUserDefaults()
   var shouldAttempt = true
   var didComplete = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.fbLoginView.delegate = self
      self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_about_me", "user_photos"]
      
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
   
   // Facebook delegate methods
   func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
      if didComplete {
      	println("User Logged In")
//         performSegueWithIdentifier("presentSearch", sender: self)
      }
      didComplete = false
   }
   
   func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
      println("User Logged Out")
   }
   
   func loginView(loginView: FBLoginView!, handleError error: NSError!) {
      println("Error: \(error.localizedDescription)")
   }
   
   func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
      //      println("in loginViewFetchedUserInfo")
      //      println("user...\(user)")
      if !shouldAttempt {
         return
      }
      shouldAttempt = false
      
      var email: String
      if let fb_email = user.objectForKey("email") as? String {
         email = fb_email
      } else {
         email = "\(user.username)@facebook.com"
      }
      
      var bio: String
      if let fb_bio = user.objectForKey("bio") as? String {
         bio = fb_bio
      } else {
         bio = "NULL"
      }
      
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users?email=\(email)&password=NULL&facebook=\(1)&firstName=\(user.first_name)&lastName=\(user.last_name)";
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
                        if let resp_bio = json["bio"] as? String {
                           let user_bio = resp_bio == "NULL" ? "No bio :(" : resp_bio
                           if let resp_age = json["age"] as? String {
                              let age = resp_age.toInt()
                              defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                              defaults.setObject(first_name, forKey: "PixieUserFirstName")
                              defaults.setObject(last_name, forKey: "PixieUserLastName")
                              defaults.setObject(resp_email, forKey: "PixieUserEmail")
                              defaults.setObject(user_bio, forKey: "PixieUserBio")
                              defaults.setObject(age, forKey: "PixieUserAge")
                              defaults.setObject(true, forKey: "PixieUserHasFB")
                              let username = first_name + last_name + userId
                              PFUser.logInWithUsernameInBackground(username, password: resp_password) {
                                 [unowned self] (user: PFUser?, error: NSError?) -> Void in
                                 if user != nil {
                                    println("Parse user successfully logged in")
                                    PFInstallation.currentInstallation().setObject(user!, forKey: "user")
                                    PFInstallation.currentInstallation().saveInBackground()
                                 } else {
                                    println("Parse log in error: \(error!)")
                                 }
                              }
                              Keychain.set(true, forKey: "loggedIn")
                              NSUserDefaults.standardUserDefaults().synchronize()
                              println("signed in userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), age: \(age!), bio: \(user_bio), hasFB: true")
                              self.wrongEmailPwLabel.hidden = true
                              didComplete = true
                              dispatch_sync(dispatch_get_main_queue()) {
                                 self.performSegueWithIdentifier("presentSearch", sender: self.self)
                              }
                           } else {
                              shouldAttempt = true
                              println("error age")
                           }
                        } else {
                           shouldAttempt = true
                           println("error bio")
                        }
                     } else {
                        shouldAttempt = true
                        println("error password")
                     }
                  } else {
                     shouldAttempt = true
                     println("error email")
                  }
               } else {
                  shouldAttempt = true
                  println("error last_name")
               }
            } else {
               shouldAttempt = true
               println("error first_name")
            }
         } else {
            shouldAttempt = true
            wrongEmailPwLabel.hidden = false
            println("error userID fb")
         }
      } else {
         shouldAttempt = true
         println("error json")
         wrongEmailPwLabel.hidden = false
      }
   }
   
   @IBAction func attemptSignIn(sender: AnyObject) {
      let email = emailField.text!
      let password = pwField.text!
      
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
                        if let resp_bio = json["bio"] as? String {
                           let user_bio = resp_bio == "NULL" ? "No bio :(" : resp_bio
                           if let resp_age = json["age"] as? String {
                              defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                              defaults.setObject(first_name, forKey: "PixieUserFirstName")
                              defaults.setObject(last_name, forKey: "PixieUserLastName")
                              defaults.setObject(resp_email, forKey: "PixieUserEmail")
                              defaults.setObject(resp_password, forKey: "PixieUserPassword")
                              defaults.setObject(user_bio, forKey: "PixieUserBio")
                              defaults.setObject(false, forKey: "PixieUserHasFB")
                              if (resp_age != "NULL") {
                                 defaults.setObject(resp_age.toInt(), forKey: "PixieUserAge")
                              }
                              let username = first_name + last_name + userId
                              PFUser.logInWithUsernameInBackground(username, password: resp_password) {
                                 [unowned self] (user: PFUser?, error: NSError?) -> Void in
                                 if user != nil {
                                    println("Parse user successfully logged in")
                                    PFInstallation.currentInstallation().setObject(user!, forKey: "user")
                                    PFInstallation.currentInstallation().saveInBackground()
                                 } else {
                                    println("Parse log in error: \(error!)")
                                 }
                              }
                              Keychain.set(true, forKey: "loggedIn")
                              NSUserDefaults.standardUserDefaults().synchronize()
                              println("signed in userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password), age: \(resp_age), bio: \(user_bio), hasFB: false")
                              self.wrongEmailPwLabel.hidden = true
                              dispatch_sync(dispatch_get_main_queue()) {
                                 self.performSegueWithIdentifier("presentSearch", sender: self.self)
                              }
                           } else {
                              println("error age")
                           }
                        } else {
                           println("error bio")
                        }
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
            println("error userID not fb")
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
         if let navVC = segue.destinationViewController as? UINavigationController {
            if let searchVC = navVC.topViewController as? SearchViewController {
               self.modalPresentationStyle = UIModalPresentationStyle.Custom
            }
         }
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
   
}