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
        self.playVideo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Keychain.bool(forKey: "loggedIn") == true {
            self.performSegueWithIdentifier("loggedSearch", sender: self)
        }
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
    
    @IBAction func unwindToInitialVC(sender: UIStoryboardSegue) {
        self.moviePlayer?.play()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

