//
//  SearchViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var webViewBG: UIWebView!
    var transitionOperator = TransitionOperator()
    var postRideTransitionOperator = PostRideTransitionOperator()
    var matchesTransitionOperator = SearchToMatchesTransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var filePath = NSBundle.mainBundle().pathForResource("highway", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        webViewBG.userInteractionEnabled = false
        
        toolBar.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        toolBar.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)
        toolBar.tintColor = UIColor.whiteColor()
      
        searchBar.delegate = self
    }
   
   func searchBarSearchButtonClicked(searchBar: UISearchBar) {
      performSegueWithIdentifier("showMatches", sender: self)
   }
    
    // handles hiding keyboard when user touches outside of keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func presentNavigation(sender: AnyObject?) {
        performSegueWithIdentifier("presentNav", sender: self)
    }
    @IBAction func presentPostRide(sender: AnyObject) {
        performSegueWithIdentifier("postRideSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as UIViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.transitionOperator
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

