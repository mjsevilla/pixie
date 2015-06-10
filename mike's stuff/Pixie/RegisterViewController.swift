//
//  RegisterViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/26/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, FBLoginViewDelegate, UITextFieldDelegate {
   
   @IBOutlet var fbLoginView: FBLoginView!
   @IBOutlet weak var cancelBtn: UIBarButtonItem!
   @IBOutlet weak var registerBtn: UIBarButtonItem!
   @IBOutlet weak var inputBG: UIView!
   @IBOutlet weak var nameField: UITextField!
   @IBOutlet weak var emailField: UITextField!
   @IBOutlet weak var pwField: UITextField!
   @IBOutlet weak var nameHeading: UIView!
   @IBOutlet weak var emailHeading: UIView!
   @IBOutlet weak var pwHeading: UIView!
   @IBOutlet weak var noLastNameLabel: UILabel!
   var user: PFUser?
   var shouldAttempt = true
   
   let defaults = NSUserDefaults.standardUserDefaults()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      self.fbLoginView.delegate = self
      self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_about_me", "user_photos"]
      
      cancelBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
      registerBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
      
      inputBG.layer.shadowOpacity = 0.5
      inputBG.layer.shadowOffset = CGSize(width: 1, height: 3)
      inputBG.layer.cornerRadius = 8.0
      
      nameField.layer.cornerRadius = 8.0
      emailField.layer.cornerRadius = 8.0
      pwField.layer.cornerRadius = 8.0
      nameHeading.layer.cornerRadius = 8.0
      emailHeading.layer.cornerRadius = 8.0
      pwHeading.layer.cornerRadius = 8.0
      
      nameField.delegate = self
      emailField.delegate = self
      pwField.delegate = self
      noLastNameLabel.hidden = true
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      for view in self.fbLoginView.subviews as! [UIView] {
         if view.isKindOfClass(UILabel) {
            var lbl = view as! UILabel
            lbl.text = "Register using Facebook"
         }
      }
   }
   
   @IBAction func textFieldsArePopulated(sender: AnyObject) {
      registerBtn.enabled = count(nameField.text) > 0 &&
         count(emailField.text) > 0 &&
         count(pwField.text) > 0
   }
   
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      registerBtn.enabled = false
      
      if !emailField.text.isEmpty && !nameField.text.isEmpty && !pwField.text.isEmpty {
         registerBtn.enabled = true
      }
      if textField == nameField && !nameField.text.isEmpty {
         self.emailField.becomeFirstResponder()
         return true
      }
      else if textField == emailField && !emailField.text.isEmpty {
         self.pwField.becomeFirstResponder()
         return true
      }
      else {
         self.attemptRegisterUser(self)
         return true
      }
   }
   
   // handles hiding keyboard when user touches outside of keyboard
   override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   // Facebook delegate methods
   func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
      println("User Logged In")
   }
   
   func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
//      println("in loginViewFetchedUserInfo")
      //      println("user...\(user)")
      noLastNameLabel.hidden = true
      self.view.endEditing(true)
      if nameField.isFirstResponder() { nameField.resignFirstResponder() }
      if emailField.isFirstResponder() { emailField.resignFirstResponder() }
      if pwField.isFirstResponder() { pwField.resignFirstResponder() }
      
      if !shouldAttempt {
         return
      }
      
      if checkIfFBUserExists(loginView, user: user) {
         return
      }
      shouldAttempt = false
      
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users";
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
      var session = NSURLSession.sharedSession()
      request.HTTPMethod = "POST"
      var err: NSError?
      
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
      
      let newUser = CreateUser()
      var reqText = newUser.generateHttp(user.first_name, lastName: user.last_name, email: email, password: "NULL", bday: user.birthday, bio: bio, hasFB: true)
      //      println("reqText...\n\(reqText)")
      
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err) // This Line fills the web service with required parameters.
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
         var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
         if(err != nil) {
            self.shouldAttempt = true
            println(err!.localizedDescription)
         }
         else {
            var parseError : NSError?
            
            // parse data
            let unparsedArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            if let resp = unparsedArray as? NSDictionary {
               let defaults = NSUserDefaults.standardUserDefaults()
               if let userId = resp["userId"] as? String {
                  if let first_name = resp["first_name"] as? String {
                     if let last_name = resp["last_name"] as? String {
                        if let resp_email = resp["email"] as? String {
                           if let resp_password = resp["password"] as? String {
                              if let resp_bio = resp["bio"] as? String {
                                 let user_bio = resp_bio == "NULL" ? "No bio :(" : resp_bio
                                 if let resp_age = resp["age"] as? String {
                                    let age = resp_age.toInt()
                                    defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                                    defaults.setObject(first_name, forKey: "PixieUserFirstName")
                                    defaults.setObject(last_name, forKey: "PixieUserLastName")
                                    defaults.setObject(resp_email, forKey: "PixieUserEmail")
                                    defaults.setObject(resp_password, forKey: "PixieUserPassword")
                                    defaults.setObject(user_bio, forKey: "PixieUserBio")
                                    defaults.setObject(age, forKey: "PixieUserAge")
                                    defaults.setObject(true, forKey: "PixieUserHasFB")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    self.user = PFUser()
                                    if let _user = self.user {
                                       _user.username = first_name + last_name + userId
                                       _user.password = resp_password
                                       _user.email = resp_email
                                       _user["name"] = "\(first_name) \(last_name)"
                                       _user["userId"] = userId
                                       _user["age"] = age
                                       _user.signUpInBackgroundWithBlock {
                                          (succeeded: Bool, error: NSError?) -> Void in
                                          if let error = error {
                                             let errorString = error.userInfo?["error"] as? NSString
                                             println("Parse error: \(errorString!)")
                                          } else {
                                             PFInstallation.currentInstallation().setObject(_user, forKey: "user")
                                             PFInstallation.currentInstallation().saveInBackground()
                                             println("Facebook registration successful")
                                          }
                                       }
                                    }
                                    Keychain.set(true, forKey: "loggedIn")
                                    println("created userId: \(userId), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password), age: \(age!), bio: \(user_bio), hasFB: true")
                                    self.performSegueWithIdentifier("presentSearch", sender: self.self)
                                 } else {
                                    self.shouldAttempt = true
                                    println("error age")
                                 }
                              } else {
                                 self.shouldAttempt = true
                                 println("error bio")
                              }
                           } else {
                              self.shouldAttempt = true
                              println("error password")
                           }
                        } else {
                           self.shouldAttempt = true
                           println("error email")
                        }
                     } else {
                        self.shouldAttempt = true
                        println("error last_name")
                     }
                  } else {
                     self.shouldAttempt = true
                     println("error first_name")
                  }
               } else {
                  self.shouldAttempt = true
                  println("error userID")
               }
            }
            else {
               self.shouldAttempt = true
               println("Probably 500")
               println("\(parseError)")
               let defaults = NSUserDefaults.standardUserDefaults()
               defaults.setObject(3, forKey: "PixieUserId")
            }
         }
      })
      
      task.resume()
   }
   
   func checkIfFBUserExists(loginView: FBLoginView!, user: FBGraphUser!) -> Bool {
//      println("in checkIfFBUserExists")
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
                              
                              let alertController = UIAlertController(title: "Account already exists.", message: nil, preferredStyle: .Alert)
                              
                              let registerNewUserAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                                 FBSession.activeSession().closeAndClearTokenInformation()
                                 self.shouldAttempt = true
                              }
                              
                              let signInAction = UIAlertAction(title: "Sign In", style: .Default) { (action) in
                                 let age = resp_age.toInt()
                                 self.defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                                 self.defaults.setObject(first_name, forKey: "PixieUserFirstName")
                                 self.defaults.setObject(last_name, forKey: "PixieUserLastName")
                                 self.defaults.setObject(resp_email, forKey: "PixieUserEmail")
                                 self.defaults.setObject(resp_password, forKey: "PixieUserPassword")
                                 self.defaults.setObject(user_bio, forKey: "PixieUserBio")
                                 self.defaults.setObject(age, forKey: "PixieUserAge")
                                 self.defaults.setObject(true, forKey: "PixieUserHasFB")
                                 let username = first_name + last_name + userId
                                 PFUser.logInWithUsernameInBackground(username, password: resp_password) {
                                    [unowned self] (user: PFUser?, error: NSError?) -> Void in
                                    if user != nil {
                                       println("Parse user successfully logged in")
                                    } else {
                                       println("Parse log in error: \(error!)")
                                    }
                                 }
                                 Keychain.set(true, forKey: "loggedIn")
                                 NSUserDefaults.standardUserDefaults().synchronize()
                                 println("signed in userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), age: \(age!), bio: \(user_bio), hasFB: true")
                                 println("User Logged In with existing account")
                                 self.performSegueWithIdentifier("presentSearch", sender: self)
                              }
                              
                              alertController.addAction(signInAction)
                              alertController.addAction(registerNewUserAction)
                              self.presentViewController(alertController, animated: true, completion: nil)
                              return true
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
            println("error userID")
         }
      } else {
         println("error json")
      }

      return false
   }
   
   // returns an array of the users name separated by spaces
   // makes sure the first letter of each string is uppercase and the rest is lowercase
   func correctNameCase(name: String) -> [String] {
      var fullNameArr = split(name) {$0 == " "}
      for i in 0 ..< fullNameArr.count {
         var first = fullNameArr[i].substringToIndex(advance(fullNameArr[i].startIndex, 1)).uppercaseString
         var rest = fullNameArr[i].substringFromIndex(advance(fullNameArr[i].startIndex, 1)).lowercaseString
         fullNameArr[i] = first + rest
      }
      return fullNameArr
   }
   
   // returns the first name of the user which is either the first word or a concatenation of all words besides the last
   func getFirstName(fullNameArr: [String]) -> String {
      let idx = fullNameArr.count == 1 ? 1 : fullNameArr.count-1
      var first = ""
      for i in 0 ..< idx {
         first += fullNameArr[i] + " "
      }
      return first.substringToIndex(advance(first.startIndex, count(first)-1))
   }
   
   @IBAction func attemptRegisterUser(sender: AnyObject) {
      var fullNameArr = correctNameCase(nameField.text!)
      if fullNameArr.count == 1 {
         noLastNameLabel.hidden = false
         self.view.endEditing(true)
         return
      }
      let firstName = getFirstName(fullNameArr)
      let lastName = fullNameArr[fullNameArr.count-1]
      
      if checkIfUserExists() {
         return
      }
      
      
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users"
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
      request.HTTPMethod = "POST"
      var err: NSError?
      
      let newUser = CreateUser()
      var reqText = newUser.generateHttp(firstName, lastName: lastName, email: emailField.text!, password: pwField.text!, bday: "NULL", bio: "NULL", hasFB: false)
      println("reqText...\n\(reqText)")
      
      //This Line fills the web service with required parameters.
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      var response: NSURLResponse?
      
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
         println("json after attemptRegisterUser...\njson.count: \(json.count)\n\(json)")
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
                              if (resp_age != "NULL") {
                                 defaults.setObject(resp_age.toInt(), forKey: "PixieUserAge")
                              }
                              defaults.setObject(false, forKey: "PixieUserHasFB")
                              NSUserDefaults.standardUserDefaults().synchronize()
                              self.user = PFUser()
                              if let _user = self.user {
                                 _user.username = first_name + last_name + userId
                                 _user.password = resp_password
                                 _user.email = resp_email
                                 _user["name"] = "\(first_name) \(last_name)"
                                 _user["userId"] = userId
                                 _user["age"] = resp_age == "NULL" ? NSNull() : resp_age.toInt()
                                 _user.signUpInBackgroundWithBlock {
                                    (succeeded: Bool, error: NSError?) -> Void in
                                    if let error = error {
                                       let errorString = error.userInfo?["error"] as? NSString
                                       println("Parse error: \(errorString!)")
                                    } else {
                                       PFInstallation.currentInstallation().setObject(_user, forKey: "user")
                                       PFInstallation.currentInstallation().saveInBackground()
                                       println("Pixie registration successful")
                                    }
                                 }
                                 Keychain.set(true, forKey: "loggedIn")
                              }
                              println("created userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password), age: \(resp_age), bio: \(user_bio), hasFB: false")
                              self.performSegueWithIdentifier("presentSearch", sender: self)
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
            println("error userID")
         }
      } else {
         println("error json")
      }
   }
   
   func checkIfUserExists() -> Bool {
      let email = emailField.text!
      let password = pwField.text!
      
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users?email=\(email)&password=\(password)&facebook=\(0)&firstName=NULL&lastName=NULL"
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
         println("json after checkIfUserExists...\njson.count: \(json.count)\n\(json)")
         if let userIdStr = json["userId"] as? String {
            let userId = userIdStr.toInt()
            if let first_name = json["first_name"] as? String {
               if let last_name = json["last_name"] as? String {
                  if let resp_email = json["email"] as? String {
                     if let resp_password = json["password"] as? String {
                        if let resp_bio = json["bio"] as? String {
                           let user_bio = resp_bio == "NULL" ? "No bio :(" : resp_bio
                           if let resp_age = json["age"] as? String {
                              
                              let alertController = UIAlertController(title: "Account already exists.", message: nil, preferredStyle: .Alert)
                              
                              let registerNewUserAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                              }
                              
                              let signInAction = UIAlertAction(title: "Sign In", style: .Default) { (action) in
                                 self.defaults.setObject(userId, forKey: "PixieUserId")
                                 self.defaults.setObject(first_name, forKey: "PixieUserFirstName")
                                 self.defaults.setObject(last_name, forKey: "PixieUserLastName")
                                 self.defaults.setObject(resp_email, forKey: "PixieUserEmail")
                                 self.defaults.setObject(resp_password, forKey: "PixieUserPassword")
                                 self.defaults.setObject(user_bio, forKey: "PixieUserBio")
                                 if (resp_age != "NULL") {
                                    self.defaults.setObject(resp_age.toInt(), forKey: "PixieUserAge")
                                 }
                                 self.defaults.setObject(false, forKey: "PixieUserHasFB")
                                 let username = first_name + last_name + userIdStr
                                 PFUser.logInWithUsernameInBackground(username, password: resp_password) {
                                    [unowned self] (user: PFUser?, error: NSError?) -> Void in
                                    if user != nil {
                                       println("Parse user successfully logged in")
                                    } else {
                                       println("Parse log in error: \(error!)")
                                    }
                                 }
                                 Keychain.set(true, forKey: "loggedIn")
                                 NSUserDefaults.standardUserDefaults().synchronize()
                                 println("signed in userId: \(userId), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password), age: \(resp_age), bio: \(user_bio), hasFB: false")
                                 self.performSegueWithIdentifier("presentSearch", sender: self)
                              }
                              
                              alertController.addAction(signInAction)
                              alertController.addAction(registerNewUserAction)
                              self.presentViewController(alertController, animated: true, completion: nil)
                              return true
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
            println("error userID")
         }
      } else {
         println("error json")
      }

      return false
   }
   
   func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
      FBSession.activeSession().closeAndClearTokenInformation()
      println("User Logged Out")
   }
   
   func loginView(loginView: FBLoginView!, handleError error: NSError!) {
      println("Error: \(error.localizedDescription)")
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      println("in prepareForSegue with identifier \(segue.identifier!)")
      noLastNameLabel.hidden = true
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