//
//  InitialViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var webViewBG: UIWebView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var filePath = NSBundle.mainBundle().pathForResource("highway", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        webViewBG.userInteractionEnabled = false
        webViewBG.scalesPageToFit = true
    }
    
    // exit segue from sign in view
    @IBAction func cancelActionUnwindToIntialVC(sender: UIStoryboardSegue) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "presentRegister" {
            if let registerVC = segue.destinationViewController as? SearchViewController {}
        }
        if segue.identifier == "presentSignIn" {
            if let signInVC = segue.destinationViewController as? SignInViewController {}
        }
        if segue.identifier == "presentRegister" {
            if let signInVC = segue.destinationViewController as? RegisterViewController {}
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

