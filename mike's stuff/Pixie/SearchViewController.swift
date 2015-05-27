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
    var latitude: Double!
    var longitude: Double!
    
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
		
		activeSearchBar = searchBar
		
		searchBar.layer.cornerRadius = 8.0
		searchBar.layer.masksToBounds = true
		searchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
		searchBar.layer.borderWidth = 1.0
		searchBar.hidden = false
		searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		//startingTableView = UITableView()
		startingTableView.delegate = self
		startingTableView.dataSource = self
		startingTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
		startingTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		startingTableView.hidden = true
		startingTableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.75)
		startingTableView.layer.cornerRadius = 5
		
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
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println("tableView numberOfRowsInSection: \(startingVC.places.count)")
		return startingVC.places.count
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		println("numberOfSectionsInTableView: 1")
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell
		
		cell = self.startingTableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
		
		let place = startingVC.places[indexPath.row]
		
		cell.textLabel?.text = place.description
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
		
		println("tableView cellForRowAtIndexPath: \(indexPath), place.description: \(place.description)")
		
		return cell
	}
	
	func setTripInfo(searchBar: UISearchBar, city:String, state:String) {
		searchBar.text = city + ", " + state
		performSegueWithIdentifier("showMatches", sender: self)
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (activeSearchBar == searchBar) {
			println("tableView didSelectRowAtIndexPath: \(startingVC.places[indexPath.row])")
			startingVC.delegate?.placeSelected?(startingVC.places[indexPath.row])
			let place = startingVC.places[indexPath.row]
			place.getDetails { details in
				self.setTripInfo(self.searchBar, city: details.city, state: details.state)
			}
			startingTableView.hidden = true
		}
	}
	
	
	override func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		self.activeSearchBar = searchBar
		println("in searchBar with \(searchText)")
		
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
		println("in getPlaces with \(searchString)")
		
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
						println("before refreshUI()")
						println("places: \(self.startingVC.places)")
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
                destinationVC.latitude = self.latitude
                destinationVC.longitude = self.longitude
                destinationVC.searchDate = getCurrentDate()
                destinationVC.searchTime = "25:00:00"
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
        self.latitude = placemark.location.coordinate.latitude
        self.longitude = placemark.location.coordinate.longitude
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