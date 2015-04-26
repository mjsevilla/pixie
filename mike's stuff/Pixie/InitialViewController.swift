//
//  InitialViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class InitialViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    var moviePlayer: MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playVideo()
    }
    
    func playVideo() -> Bool {
        let path = NSBundle.mainBundle().pathForResource("pixieWelcomeVideoColor", ofType: "mp4")
        let url = NSURL.fileURLWithPath(path!)
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer {
            player.view.frame = self.view.bounds
            player.controlStyle = .None
            player.prepareToPlay()
            player.repeatMode = .One
            player.scalingMode = .AspectFill
            self.view.addSubview(player.view)
            self.view.sendSubviewToBack(player.view)
            
            return true
        }
        
        return false
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

