//
//  SearchViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toolBar: UIToolbar!
    let navTransitionOperator = NavigationTransitionOperator()
    let postRideTransitionOperator = PostRideTransitionOperator()
    let matchesTransitionOperator = SearchToMatchesTransitionOperator()
    var moviePlayer: MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playVideo()
        
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        toolBar.tintColor = UIColor.whiteColor()
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
        searchBar.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedId = defaults.stringForKey("PixieUserId") {
            println("userId found: \(savedId)")
        } else {
            println("userId not found")
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
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.performSegueWithIdentifier("presentNav", sender: self)
        }
        if sender.direction == .Left {
            self.performSegueWithIdentifier("postRideSegue", sender: self)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSegueWithIdentifier("showMatches", sender: self)
    }
    
    // handles hiding keyboard when user touches outside of keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func presentPostRide(sender: AnyObject) {
        performSegueWithIdentifier("postRideSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as! NavigationViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.navTransitionOperator
            toViewController.presentingView = self
            
        } else if segue.identifier == "postRideSegue" {
            if let destinationVC = segue.destinationViewController as? PostRideViewController {
                destinationVC.transitioningDelegate = self.postRideTransitionOperator
                destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            }
        } else if segue.identifier == "showMatches" {
            if let destinationVC = segue.destinationViewController as? MatchesViewController {
                destinationVC.transitioningDelegate = self.matchesTransitionOperator
                destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            }
        }
    }
    
    @IBAction func unwindToSearchView(sender: UIStoryboardSegue) {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

