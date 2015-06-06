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
import CoreLocation

class SearchViewController: AutocompleteViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pixieLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toolBar: UIToolbar!
    var activeSearchBar: UISearchBar!
    var startingVC = GooglePlacesAutocompleteContainer(apiKey: "AIzaSyB6Gv8uuTNh_ZN-Hk8H3S5RARpQot_6I-k", placeType: .All)
    @IBOutlet var startingTableView: UITableView!
    
    let navTransitionOperator = NavigationTransitionOperator()
    let postRideTransitionOperator = PostRideTransitionOperator()
    let matchesTransitionOperator = SearchToMatchesTransitionOperator()
    var moviePlayer: MPMoviePlayerController?
    let locationManager = CLLocationManager()
    var startLat: Double!
    var startLon: Double!
    var endLat: Double!
    var endLon: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.playVideo()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        toolBar.tintColor = UIColor.whiteColor()
        
        activeSearchBar = searchBar
        
        searchBar.layer.cornerRadius = 8.0
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderColor = UIColor.clearColor().CGColor
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.layer.borderWidth = 1.0
        searchBar.hidden = false
        searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //startingTableView = UITableView()
        startingTableView.backgroundColor = UIColor.clearColor()
        startingTableView.delegate = self
        startingTableView.dataSource = self
        startingTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        startingTableView.registerClass(ACTableViewCell.self, forCellReuseIdentifier: "cell")
        startingTableView.hidden = true
        startingTableView.rowHeight = UITableViewAutomaticDimension
        startingTableView.estimatedRowHeight = 100.0
        startingTableView.tableFooterView = UIView(frame: CGRectZero)
        
        startingVC.delegate = self
        searchBar.delegate = self
        startingVC.searchBar = self.searchBar
        startingVC.tableView = self.startingTableView
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let savedId = defaults.stringForKey("PixieUserId") {
//            if let savedFirstName = defaults.stringForKey("PixieUserFirstName") {
//                if let savedLastName = defaults.stringForKey("PixieUserLastName") {
//                    println("userId found: \(savedId)")
//                    println("firstName found: \(savedFirstName)")
//                    println("lastName found: \(savedLastName)")
//                } else {
//                    println("lastName not found")
//                }
//            } else {
//                println("firstName not found")
//            }
//        } else {
//            println("userId not found")
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.pixieLabel.hidden = true
        self.searchBar.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.startingTableView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.searchBar.frame.origin.y -= 150
        self.startingTableView.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification) {
        self.pixieLabel.hidden = false
        self.searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.startingTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.searchBar.frame.origin.y += 150
        self.startingTableView.frame.origin.y += 150
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
            player.play()
            self.view.addSubview(player.view)
            self.view.sendSubviewToBack(player.view)
            
            return true
        }
        
        return false
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        dispatch_async(dispatch_get_main_queue(), {
            if sender.direction == .Right {
                self.performSegueWithIdentifier("presentNav", sender: self)
            }
            else if sender.direction == .Left {
                self.performSegueWithIdentifier("postRideSegue", sender: self)
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		println("tableView numberOfRowsInSection: \(startingVC.places.count)")
        return startingVC.places.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//		println("numberOfSectionsInTableView: 1")
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ACTableViewCell
        cell = self.startingTableView.dequeueReusableCellWithIdentifier("cell") as! ACTableViewCell
        
        let place = startingVC.places[indexPath.row]
        cell.placeLabel.text = place.description
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.75)
        
        //		println("tableView cellForRowAtIndexPath: \(indexPath), place.description: \(place.description)")
        
        return cell
    }
    
    func setTripInfo(searchBar: UISearchBar, city:String, state:String) {
        searchBar.text = city + ", " + state
        performSegueWithIdentifier("showMatches", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (activeSearchBar == searchBar) {
            //			println("tableView didSelectRowAtIndexPath: \(startingVC.places[indexPath.row])")
            startingVC.delegate?.placeSelected?(startingVC.places[indexPath.row])
            let place = startingVC.places[indexPath.row]
            place.getDetails { details in
                self.endLat = details.latitude
                self.endLon = details.longitude
                self.setTripInfo(self.searchBar, city: details.city, state: details.state)
            }
            startingTableView.hidden = true
        }
    }
    
    
    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.activeSearchBar = searchBar
        //		println("in searchBar with \(searchText)")
        
        if (searchText == "") {
            if (self.activeSearchBar == searchBar) {
                startingVC.places = []
                startingTableView.hidden = true
            }
        } else {
            getPlaces(searchText)
        }
    }
    
    func getPlaces(searchString: String) {
//		println("in getPlaces with \(searchString)")
        
        if (self.activeSearchBar == searchBar) {
            GooglePlacesRequestHelpers.doRequest(
                "https://maps.googleapis.com/maps/api/place/autocomplete/json",
                params: [
                    "input": searchString,
                    "types": startingVC.placeType.description,
                    "key": startingVC.apiKey ?? ""
                ]
                ) { json in
                    if let predictions = json["predictions"] as? Array<[String: AnyObject]> {
                        self.startingVC.places = predictions.map { (prediction: [String: AnyObject]) -> Place in
                            return Place(prediction: prediction, apiKey: self.startingVC.apiKey)
                        }
                        
                        self.reloadInputViews()
//						println("before refreshUI()")
//						println("places: \(self.startingVC.places)")
                        self.refreshUI()
                        self.startingTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
                        self.startingTableView.hidden = false
                        self.startingVC.delegate?.placesFound?(self.startingVC.places)
                    }
            }
        }
    }
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            if (self.activeSearchBar == self.searchBar) {
                self.startingTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
            }
        });
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
                destinationVC.startLat = self.startLat
                destinationVC.startLon = self.startLon
                destinationVC.endLat = self.endLat
                destinationVC.endLon = self.endLon
                destinationVC.searchDate = getCurrentDate()
                destinationVC.searchTime = "25:00:00"
            }
        }
    }
    
    @IBAction func unwindToSearchView(sender: UIStoryboardSegue) {
        self.moviePlayer?.play()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.setLocationInfo(pm)
            } else {
                println("Error with the data.")
            }
        })
    }
    
    func setLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        self.startLat = placemark.location.coordinate.latitude
        self.startLon = placemark.location.coordinate.longitude
        //        println("Current location: \(placemark.locality), \(placemark.administrativeArea), \(placemark.country)")
        //        println("latitude: \(latitude), longitude: \(longitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    func getCurrentDate() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currDate = dateFormatter.stringFromDate(NSDate())
        return currDate
    }
}

extension SearchViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        
        println(place.description)
        
        place.getDetails { details in
            println(details)
        }
    }
}