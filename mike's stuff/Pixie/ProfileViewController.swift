//
//  ProfileViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 3/9/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var bioField: UITextView!
    var navTransitionOperator = NavigationTransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
        
        firstName.layer.borderWidth = 1.25
        firstName.layer.borderColor = UIColor.lightGrayColor().CGColor
        lastName.layer.borderWidth = 1.25
        lastName.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        bioField.delegate = self
        bioField.text = "Tell us about yourself!"
        bioField.textColor = UIColor.lightGrayColor()
        bioField.layer.borderWidth = 1.25
        bioField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        profPic.layer.borderWidth = 1.25
        profPic.layer.borderColor = UIColor.lightGrayColor().CGColor
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
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
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