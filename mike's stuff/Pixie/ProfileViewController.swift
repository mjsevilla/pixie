//
//  ProfileViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 3/9/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var charCount: UILabel!
	@IBOutlet weak var saveBtn: UIBarButtonItem!
	@IBOutlet weak var profPic: UIImageView!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var lastName: UITextField!
	@IBOutlet weak var age: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var bioField: UITextView!
	var userId: Int! = -1
	var navTransitionOperator = NavigationTransitionOperator()
	//var newMedia: Bool?
	let imagePicker = UIImagePickerController()
	let defaults = NSUserDefaults.standardUserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadUsersFromAPI()
		
		// Do any additional setup after loading the view, typically from a nib.
		saveBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
		
		bioField.delegate = self
		if (bioField.text == "NULL") {
			bioField.text = "Tell us about yourself!"
		}
		bioField.layer.cornerRadius = 8.0
		bioField.layer.masksToBounds = true
		bioField.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		bioField.layer.borderWidth = 1.0
		
		firstName.delegate = self
		firstName.layer.cornerRadius = 8.0
		firstName.layer.masksToBounds = true
		firstName.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		firstName.layer.borderWidth = 1.0
		
		lastName.delegate = self
		lastName.layer.cornerRadius = 8.0
		lastName.layer.masksToBounds = true
		lastName.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		lastName.layer.borderWidth = 1.0
		
		age.delegate = self
		if (age.text == "NULL") {
			age.text = "";
		}
		age.layer.cornerRadius = 8.0
		age.layer.masksToBounds = true
		age.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		age.layer.borderWidth = 1.0
		
		email.delegate = self
		email.layer.cornerRadius = 8.0
		email.layer.masksToBounds = true
		email.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		email.layer.borderWidth = 1.0
		
		password.delegate = self
		password.layer.cornerRadius = 8.0
		password.layer.masksToBounds = true
		password.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		password.layer.borderWidth = 1.0
		password.secureTextEntry = true
		
		if (profPic.image == nil) {
			profPic.image = UIImage(named: "default.png")
		}
		profPic.layer.cornerRadius = 8.0
		profPic.layer.masksToBounds = true
		profPic.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		profPic.layer.borderWidth = 1.0
		
		imagePicker.delegate = self
		
		var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
		rightSwipe.direction = .Right
		view.addGestureRecognizer(rightSwipe)
	}
	
	// limit input to 300 characters
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if (range.length + range.location > count(bioField.text)) {
			return false
		}
		var newLength = NSInteger()
		newLength = count(bioField.text) + count(text) - range.length
		
		return newLength <= 300
	}
	
	// mimic having a placeholder for the bioField
	func textViewDidBeginEditing(textView: UITextView) {
		if bioField.text.isEmpty || bioField.text == "Tell us about yourself!" {
			bioField.text = nil
			bioField.textColor = UIColor.blackColor()
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if bioField.text.isEmpty {
			bioField.text = "Tell us about yourself!"
			bioField.textColor = UIColor.lightGrayColor()
		}
	}
	
	@IBAction func textFieldsDidChange(sender: AnyObject) {
		saveBtn.enabled = true
	}
	
	@IBAction func loadImageTapped(sender: UIButton) {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			profPic.contentMode = .ScaleAspectFit
			profPic.image = pickedImage
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func textViewDidChange(textView: UITextView) {
		// update character count
		charCount.text = NSString(format: "%d", 300 - count(bioField.text)) as String
		
		saveBtn.enabled = true
	}
	
	// handles hiding keyboard when user touches outside of keyboard
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		self.view.endEditing(true)
	}
	
	func loadUsersFromAPI() {
		if let savedId = defaults.stringForKey("PixieUserId") {
			userId = savedId.toInt()
		}
		
		var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users/\(userId)"
		let url = NSURL(string: urlString)
		var request = NSURLRequest(URL: url!)
		var response: NSURLResponse?
		var error: NSErrorPointer = nil
		var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
		
		if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
			//            println("json...\n\(json)\n")
			if let userIdStr = json["userId"] as? String {
				let userId = userIdStr.toInt()!
				//user.userId = userId
				if let first_name = json["first_name"] as? String {
					if let last_name = json["last_name"] as? String {
						//user.setName(first_name, lastName: last_name)
						firstName.text = first_name
						lastName.text = last_name
						if let ageStr = json["age"] as? String {
							//let age = ageStr.toInt()!
							//user.age = age
							age.text = ageStr
						}
						if let emailStr = json["email"] as? String {
							email.text = emailStr
						}
						if let pwStr = json["password"] as? String {
							password.text = pwStr
						}
						if let bio = json["bio"] as? String {
							if count(bio) > 0 {
								//user.bio = bio
								bioField.text = bio
								defaults.setObject(bioField.text, forKey: "PixieUserBio")
							}
						}
						if let photoURL = json["photoURL"] as? String {
							if count(photoURL) > 0 {
								//user.setProfPic(photoURL)
								profPic.image = UIImage(data: NSData(contentsOfURL: NSURL(string: photoURL)!)!)
							}
						}
					} else {
						println("error: last_name")
					}
				} else {
					println("error: first_name")
				}
			} else {
				println("error: userId")
			}
		} else {
			println("error: json object with userId: \(userId)")
		}
	}
	
	@IBAction func saveBtnTapped(sender: AnyObject) {
		var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users"
		//var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/editUser"
		var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		request.HTTPMethod = "PUT"
		var err: NSError?
		var reqText = ["userId": "\(userId)", "first_name": "\(firstName.text)", "last_name": "\(lastName.text)", "age": "\(age.text)", "email": "\(email.text)", "password": "\(password.text)", "bio": "\(bioField.text)"]
		//println("reqText...\n\(reqText)")
		
		//This Line fills the web service with required parameters.
		request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		let defaults = NSUserDefaults.standardUserDefaults()
		var response: NSURLResponse?
		
		var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
		
		if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
			//   println("json after put request...\njson.count: \(json.count)\n\(json)")
			if let userIdStr = json["userId"] as? Int {
				if let first_name = json ["first_name"] as? String {
					if first_name != firstName.text {
						println("first name doesn't match")
					}
					if let last_name = json ["last_name"] as? String {
						if last_name != lastName.text {
							println("last name doesn't match")
						}
						if let ageInt = json ["age"] as? Int {
							var ageStr = String(ageInt)
							if ageStr != age.text {
								println("age doesn't match")
							}
							if let emailStr = json ["email"] as? String {
								if emailStr != email.text {
									println("email doesn't match")
								}
								if let pwStr = json ["password"] as? String {
									if pwStr != password.text {
										println("password doesn't match")
									}
									if let bio = json ["bio"] as? String {
										if bio != bioField.text {
											println("bio doesn't match")
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
							println("error age")
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
		
		performSegueWithIdentifier("presentProfile", sender: self)
	}
	
	@IBAction func backBtnTapped(sender: AnyObject) {
		performSegueWithIdentifier("presentProfile", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "presentProfile" {
			if let profVC = segue.destinationViewController as? MyProfileViewController {
				self.modalPresentationStyle = UIModalPresentationStyle.Custom
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