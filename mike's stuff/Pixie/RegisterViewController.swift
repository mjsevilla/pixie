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
   @IBOutlet weak var wrongEmailPwLabel: UILabel!
   
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
      wrongEmailPwLabel.hidden = true
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
      println("This is where you perform a segue.")
      performSegueWithIdentifier("presentSearch", sender: self)
   }
   
   // calculate age from birthday string of fb user
   func calculateAge (birthdayString: String) -> NSInteger {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "MM/dd/yyyy"
      let birthday = dateFormatter.dateFromString(birthdayString)!
      
      var userAge : NSInteger = 0
      var calendar : NSCalendar = NSCalendar.currentCalendar()
      var unitFlags : NSCalendarUnit = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay
      var dateComponentNow : NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
      var dateComponentBirth : NSDateComponents = calendar.components(unitFlags, fromDate: birthday)
      
      if ( (dateComponentNow.month < dateComponentBirth.month) ||
         ((dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day))
         )
      {
         return dateComponentNow.year - dateComponentBirth.year - 1
      }
      else {
         return dateComponentNow.year - dateComponentBirth.year
      }
   }
   
   func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
      println("in loginViewFetchedUserInfo")
      println("user...\(user)")
      
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users";
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
      var session = NSURLSession.sharedSession();
      request.HTTPMethod = "POST"
      var err: NSError?
      
      var email = user.objectForKey("email") as! String
      var gender = user.objectForKey("gender") as! String
      var birthday = user.objectForKey("birthday") as! String
      let firstName = user.first_name
      let lastName = user.last_name
      let age = calculateAge(user.birthday)
      let bio = user.objectForKey("bio") as! String
      
      
//      let newUser = CreateUser();
//      var reqText = newUser.generateHttp(name, emailParam: email, password: "facebook", genderParam: gender, bday: birthday);
      var reqText = ["first_name": "\(firstName)", "last_name": "\(lastName)", "age": "\(age)", "email": "\(email)", "password": "NULL", "bio": "\(bio)", "facebook": "\(1)"]
      println("reqText...\n\(reqText)")
      
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err) // This Line fills the web service with required parameters.
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
         var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
         if(err != nil) {
            println(err!.localizedDescription)
            self.wrongEmailPwLabel.hidden = false
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
                              defaults.setObject(userId.toInt(), forKey: "PixieUserId")
                              defaults.setObject(first_name, forKey: "PixieUserFirstName")
                              defaults.setObject(last_name, forKey: "PixieUserLastName")
                              defaults.setObject(resp_email, forKey: "PixieUserEmail")
                              defaults.setObject(resp_password, forKey: "PixieUserPassword")
                              NSUserDefaults.standardUserDefaults().synchronize()
                              println("created userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password)")
                              self.wrongEmailPwLabel.hidden = true
                              self.performSegueWithIdentifier("presentSearch", sender: self)
                           } else {
                              println("error last_name")
                           }
                        } else {
                           println("error last_name")
                        }
                     } else {
                        println("error last_name")
                     }
                  } else {
                     println("error first_name")
                  }
               } else {
                  self.wrongEmailPwLabel.hidden = false
                  println("error userID")
               }
            }
            else {
               println("Probably 500")
               println("\(parseError)")
               let defaults = NSUserDefaults.standardUserDefaults()
               defaults.setObject(3, forKey: "PixieUserId")
            }
         }
      })
      task.resume()
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
      let firstName = getFirstName(fullNameArr)
      let lastName = fullNameArr.count == 1 ? "" : fullNameArr[fullNameArr.count-1]
      let email = emailField.text!
      let password = pwField.text!
   
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users"
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
      request.HTTPMethod = "POST"
      var err: NSError?
      var reqText = ["first_name": "\(firstName)", "last_name": "\(lastName)", "age": "NULL", "email": "\(email)", "password": "\(password)", "bio": "NULL", "facebook": "\(0)"]
//      println("reqText...\n\(reqText)")
      
      //This Line fills the web service with required parameters.
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      let defaults = NSUserDefaults.standardUserDefaults()
      var response: NSURLResponse?
      
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
//         println("json after post request...\njson.count: \(json.count)\n\(json)")
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
                        NSUserDefaults.standardUserDefaults().synchronize()
                        println("created userId: \(userId.toInt()!), first_name: \(first_name), last_name: \(last_name), email: \(resp_email), password: \(resp_password)")
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
         wrongEmailPwLabel.hidden = false
         println("error json")
      }
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