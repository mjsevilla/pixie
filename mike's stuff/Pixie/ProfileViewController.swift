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
	var navTransitionOperator = NavigationTransitionOperator()
	//var newMedia: Bool?
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		saveBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
		
		bioField.delegate = self
		bioField.text = "Tell us about yourself!"
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
		
		profPic.image = UIImage(named: "default.png")
		profPic.layer.cornerRadius = 8.0
		profPic.layer.masksToBounds = true
		profPic.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		profPic.layer.borderWidth = 1.0
		
		imagePicker.delegate = self
		
		var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
		rightSwipe.direction = .Right
		view.addGestureRecognizer(rightSwipe)
	}
	
	func handleSwipes(sender: UISwipeGestureRecognizer) {
		if sender.direction == .Right {
			self.performSegueWithIdentifier("presentNav", sender: self)
		}
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
		textView.text = nil
		textView.textColor = UIColor.blackColor()
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "Tell us about yourself!"
			textView.textColor = UIColor.lightGrayColor()
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "presentNav" {
			let toViewController = segue.destinationViewController as! NavigationViewController
			self.modalPresentationStyle = UIModalPresentationStyle.Custom
			toViewController.transitioningDelegate = self.navTransitionOperator
			toViewController.presentingView = self
		}
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