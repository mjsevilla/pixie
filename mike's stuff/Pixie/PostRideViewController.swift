//
//  PostRideViewController.swift
//  PostRide
//
//  Created by Nicole (damn straight) on wouldn't/u/lyke2know.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class PostRideViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   
   var post: Post = Post()
   
   var startingVC = GooglePlacesAutocompleteContainer(apiKey: "AIzaSyB6Gv8uuTNh_ZN-Hk8H3S5RARpQot_6I-k", placeType: .All)
   var startingTableView: UITableView!
   var endingVC = GooglePlacesAutocompleteContainer(apiKey: "AIzaSyB6Gv8uuTNh_ZN-Hk8H3S5RARpQot_6I-k", placeType: .All)
   var endingTableView: UITableView!
   var activeSearchBar: UISearchBar!
   
   var blurEffectView: UIVisualEffectView!
   var backButton: UIButton!
   var tripSectionButton: UIButton!
   var seekOfferSegment: UISegmentedControl!
   @IBOutlet weak var startingSearchBar: UISearchBar!
   @IBOutlet weak var endingSearchBar: UISearchBar!
   var startingLocTextField: UITextField!
   var endingLocTextField: UITextField!
   var edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
   var searchBarsVisible = true
   
   var dateTimeSectionButton: UIButton!
   var dateButton: UIButton!
   var datePicker: UIPickerView!
   var timeButton: UIButton!
   var timePicker: UIPickerView!
   var currentDates: [String] = []
   var hours: [String] = ["ANYTIME", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
   var minutes: [String] = ["", "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
   var ampm: [String] = ["", "AM", "PM"]
   
   var reviewSectionButton: UIButton!
   var seekOfferLabel: UILabel!
   var tripLabel: UILabel!
   var dateLabel: UILabel!
   var timeLabel: UILabel!
   var postRideButton: UIButton!
   var nextButton: UIButton!
   var section = 0
   
   var tripSectionConstraints = [String: NSLayoutConstraint]()
   var seekOfferSegmentConstraints = [String: NSLayoutConstraint]()
   var startingSearchBarConstraints = [String: NSLayoutConstraint]()
   var endingSearchBarConstraints = [String: NSLayoutConstraint]()
   var nextButtonConstraints = [String: NSLayoutConstraint]()
   
   var dateTimeSectionConstraints = [String: NSLayoutConstraint]()
   var dateButtonConstraints = [String: NSLayoutConstraint]()
   var datePickerConstraints = [String: NSLayoutConstraint]()
   var timeButtonConstraints = [String: NSLayoutConstraint]()
   var timePickerConstraints = [String: NSLayoutConstraint]()
   
   var reviewSectionConstraints = [String: NSLayoutConstraint]()
   var seekOfferLabelConstraints = [String: NSLayoutConstraint]()
   var tripLabelConstraints = [String: NSLayoutConstraint]()
   var dateLabelConstraints = [String: NSLayoutConstraint]()
   var timeLabelConstraints = [String: NSLayoutConstraint]()
   var postRideButtonConstraints = [String: NSLayoutConstraint]()
   
   var ridePostedView: RidePostedView!
   
   override func loadView() {
      super.loadView()
      
      view = UIView(frame: UIScreen.mainScreen().bounds)
      
      blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
      blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(blurEffectView)
      
      activeSearchBar = startingSearchBar
      
      loadTripSectionView()
      loadDateTimeSectionView()
      loadReviewSectionView()
      
      nextButton = UIButton()
      let nextString = NSAttributedString(string: "NEXT", attributes: [NSForegroundColorAttributeName: UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0), NSFontAttributeName: UIFont(name: "Syncopate-Regular", size: 20.0)!])
      nextButton.setAttributedTitle(nextString, forState: .Normal)
      nextButton.sizeToFit()
      nextButton.hidden = true
      nextButton.addTarget(self, action: "nextButtonPressed:", forControlEvents: .TouchUpInside)
      nextButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(nextButton)
      
      let image = UIImage(named: "back") as UIImage?
      backButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
      backButton.setImage(image, forState: .Normal)
      backButton.userInteractionEnabled = true
      backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      backButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
      view.addSubview(backButton)
      
      loadTripSectionContraints()
      loadDateTimeSectionContraints()
      loadReviewSectionConstraints()
      
      var swipeToSearchView = UISwipeGestureRecognizer(target: self, action: "swipeBack:")
      swipeToSearchView.direction = .Right
      self.view.addGestureRecognizer(swipeToSearchView)
      
      startingVC.delegate = self
      startingSearchBar.delegate = self
      startingVC.searchBar = self.startingSearchBar
      startingVC.tableView = self.startingTableView
      
      endingVC.delegate = self
      endingSearchBar.delegate = self
      endingVC.searchBar = self.endingSearchBar
      endingVC.tableView = self.endingTableView
   }
   
   func loadTripSectionView() {
      tripSectionButton = UIButton()
      tripSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      tripSectionButton.addTarget(self, action: "reviewLocations:", forControlEvents: .TouchUpInside)
      tripSectionButton.hidden = true
      tripSectionButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 22.0)
      tripSectionButton.titleLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      tripSectionButton.titleLabel?.textAlignment = .Center
      tripSectionButton.titleLabel?.numberOfLines = 1
      tripSectionButton.titleLabel?.adjustsFontSizeToFitWidth = true
      tripSectionButton.titleLabel?.lineBreakMode = .ByClipping;
      tripSectionButton.titleEdgeInsets = edgeInsets
      tripSectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(tripSectionButton)
      
      seekOfferSegment = UISegmentedControl()
      seekOfferSegment.insertSegmentWithTitle("SEEKING", atIndex: 0, animated: false)
      seekOfferSegment.insertSegmentWithTitle("OFFERING", atIndex: 1, animated: false)
      var attr = NSDictionary(object: UIFont(name: "Syncopate-Regular", size: 16.0)!, forKey: NSFontAttributeName)
      seekOfferSegment.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
      seekOfferSegment.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
      seekOfferSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
      seekOfferSegment.tintColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      view.addSubview(seekOfferSegment)
      
      startingSearchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Top, barMetrics: UIBarMetrics.Default)
      startingLocTextField = startingSearchBar.valueForKey("searchField") as? UITextField
      startingLocTextField.backgroundColor = UIColor.clearColor()
      startingLocTextField.textColor = UIColor.whiteColor()
      startingLocTextField.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      startingLocTextField.attributedPlaceholder = NSAttributedString(string:"Where are you starting from?",
         attributes:[NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16.0)!])
      startingSearchBar.layer.cornerRadius = 8.0
      startingSearchBar.layer.masksToBounds = true
      startingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      startingSearchBar.layer.borderWidth = 1.0
      startingSearchBar.hidden = true
      startingSearchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(startingSearchBar)
      
      startingTableView = UITableView()
      startingTableView.backgroundColor = UIColor.clearColor()
      startingTableView.delegate = self
      startingTableView.dataSource = self
      startingTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
      startingTableView.registerClass(ACTableViewCell.self, forCellReuseIdentifier: "cell")
      startingTableView.hidden = true
      startingTableView.rowHeight = UITableViewAutomaticDimension
      startingTableView.estimatedRowHeight = 100.0
      startingTableView.tableFooterView = UIView(frame: CGRectZero)
      view.addSubview(startingTableView)
      
      endingSearchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Top, barMetrics: UIBarMetrics.Default)
      endingLocTextField = endingSearchBar.valueForKey("searchField") as? UITextField
      endingLocTextField.backgroundColor = UIColor.clearColor()
      endingLocTextField.textColor = UIColor.whiteColor()
      endingLocTextField.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      endingLocTextField.attributedPlaceholder = NSAttributedString(string:"Where do you want to go?",
         attributes:[NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16.0)!])
      endingSearchBar.layer.cornerRadius = 8.0
      endingSearchBar.layer.masksToBounds = true
      endingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      endingSearchBar.layer.borderWidth = 1.0
      endingSearchBar.hidden = true
      endingSearchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(endingSearchBar)
      
      endingTableView = UITableView()
      endingTableView.backgroundColor = UIColor.clearColor()
      endingTableView.delegate = self
      endingTableView.dataSource = self
      endingTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
      endingTableView.registerClass(ACTableViewCell.self, forCellReuseIdentifier: "cell")
      endingTableView.hidden = true
      endingTableView.rowHeight = UITableViewAutomaticDimension
      endingTableView.estimatedRowHeight = 100.0
      endingTableView.tableFooterView = UIView(frame: CGRectZero)
      view.addSubview(endingTableView)
   }
   
   func loadDateTimeSectionView() {
      getCurrentDates()
      post.dayFormatStr = post.getDayFormatStr("Friday, January 1")
      post.timeFormatStr = post.getTimeFormatStr("ANYTIME")
      
      dateTimeSectionButton = UIButton()
      dateTimeSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      dateTimeSectionButton.addTarget(self, action: "reviewDateTime:", forControlEvents: .TouchUpInside)
      dateTimeSectionButton.titleLabel?.textAlignment = .Center
      dateTimeSectionButton.titleLabel?.numberOfLines = 1
      dateTimeSectionButton.titleLabel?.adjustsFontSizeToFitWidth = true
      dateTimeSectionButton.titleLabel?.lineBreakMode = .ByClipping;
      dateTimeSectionButton.hidden = true
      dateTimeSectionButton.titleEdgeInsets = edgeInsets
      dateTimeSectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(dateTimeSectionButton)
      
      dateButton = UIButton()
      dateButton.addTarget(self, action: "selectDate:", forControlEvents: UIControlEvents.TouchUpInside)
      let currentDateArr = currentDates[0].componentsSeparatedByString(" ")
      var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
      dateButton.setAttributedTitle(date, forState: .Normal)
      dateButton.hidden = true
      dateButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(dateButton)
      
      datePicker = UIPickerView()
      datePicker.delegate = self
      datePicker.dataSource = self
      datePicker.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
      datePicker.hidden = true;
      datePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(datePicker)
      
      timeButton = UIButton()
      timeButton.addTarget(self, action: "selectTime:", forControlEvents: UIControlEvents.TouchUpInside)
      timeButton.setAttributedTitle(NSAttributedString(string: hours[0], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30.0)!]), forState: .Normal)
      timeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      timeButton.hidden = true
      view.addSubview(timeButton)
      
      timePicker = UIPickerView()
      timePicker.delegate = self
      timePicker.dataSource = self
      timePicker.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
      timePicker.hidden = true;
      timePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(timePicker)
   }
   
   func loadReviewSectionView() {
      reviewSectionButton = UIButton()
      reviewSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      reviewSectionButton.addTarget(self, action: "reviewPost:", forControlEvents: .TouchUpInside)
      reviewSectionButton.setAttributedTitle(NSAttributedString(string: "Review", attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 22.0)!]), forState: .Normal)
      reviewSectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      reviewSectionButton.hidden = true
      reviewSectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(reviewSectionButton)
      
      seekOfferLabel = UILabel()
      seekOfferLabel.backgroundColor = UIColor.clearColor()
      seekOfferLabel.textAlignment = .Center
      seekOfferLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      seekOfferLabel.hidden = true
      self.view.addSubview(seekOfferLabel)
      
      tripLabel = UILabel()
      tripLabel.backgroundColor = UIColor.clearColor()
      tripLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      tripLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)
      tripLabel.textAlignment = .Center
      tripLabel.numberOfLines = 1
      tripLabel.adjustsFontSizeToFitWidth = true
      tripLabel.lineBreakMode = .ByClipping;
      tripLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      tripLabel.hidden = true
      self.view.addSubview(tripLabel)
      
      dateLabel = UILabel()
      dateLabel.backgroundColor = UIColor.clearColor()
      dateLabel.textAlignment = .Center
      dateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      dateLabel.hidden = true
      self.view.addSubview(dateLabel)
      
      timeLabel = UILabel()
      timeLabel.backgroundColor = UIColor.clearColor()
      timeLabel.textAlignment = .Center
      timeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      timeLabel.hidden = true
      self.view.addSubview(timeLabel)
      
      postRideButton = UIButton()
      postRideButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      postRideButton.setAttributedTitle(NSAttributedString(string: "POST!", attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "Syncopate-Regular", size: 40.0)!]), forState: .Normal)
      postRideButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      postRideButton.addTarget(self, action: "postRide:", forControlEvents: .TouchUpInside)
      postRideButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(postRideButton)
      
      ridePostedView = RidePostedView(frame: view.frame)
      ridePostedView.alpha = 0
      ridePostedView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(ridePostedView)
   }
   
   func loadTripSectionContraints() {
      let viewsDict = ["backButton":backButton, "nextButton":nextButton, "tripSectionButton":tripSectionButton, "seekOfferSegment":seekOfferSegment, "startingSearchBar":startingSearchBar, "endingSearchBar":endingSearchBar, "blurEffectView":blurEffectView, "startTable":startingTableView, "endTable":endingTableView]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[backButton(22)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tripSectionButton(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startingSearchBar(30)]-1-[startTable]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[endingSearchBar(30)]-1-[endTable]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[backButton(22)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tripSectionButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nextButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[startTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[endTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      tripSectionConstraints["Top"] = NSLayoutConstraint(item: tripSectionButton, attribute: .Top, relatedBy: .Equal, toItem: backButton, attribute: .Bottom, multiplier: 1, constant: 15.0)
      seekOfferSegmentConstraints["CenterY"] = NSLayoutConstraint(item: seekOfferSegment, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      startingSearchBarConstraints["CenterY"] = NSLayoutConstraint(item: startingSearchBar, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      endingSearchBarConstraints["CenterY"] = NSLayoutConstraint(item: endingSearchBar, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      nextButtonConstraints["Top"] = NSLayoutConstraint(item: self.nextButton, attribute: .Top, relatedBy: .Equal, toItem: self.endingSearchBar, attribute: .Bottom, multiplier: 1.0, constant: 50)
      
      startingSearchBarConstraints["Search"] = NSLayoutConstraint(item: startingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 70)
      endingSearchBarConstraints["Search"] = NSLayoutConstraint(item: endingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 70)
      
      self.view.addConstraint(tripSectionConstraints["Top"]!)
      self.view.addConstraint(seekOfferSegmentConstraints["CenterY"]!)
      self.view.addConstraint(startingSearchBarConstraints["CenterY"]!)
      self.view.addConstraint(endingSearchBarConstraints["CenterY"]!)
      self.view.layoutIfNeeded()
   }
   
   func loadDateTimeSectionContraints() {
      let viewsDict = ["dateTimeSectionButton":dateTimeSectionButton, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[dateTimeSectionButton(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[dateTimeSectionButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[timePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      dateTimeSectionConstraints["Top"] = NSLayoutConstraint(item: dateTimeSectionButton, attribute: .Top, relatedBy: .Equal, toItem: tripSectionButton, attribute: .Bottom, multiplier: 1.0, constant: 1)
      dateTimeSectionConstraints["Bottom"] = NSLayoutConstraint(item: dateTimeSectionButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
      dateButtonConstraints["Top"] = NSLayoutConstraint(item: dateButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: self.view.center.y - dateButton.frame.height - 0.5 * timeButton.frame.height)
      datePickerConstraints["Top"] = NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["Top"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: datePicker.frame.height - timeButton.frame.height)
      timePickerConstraints["Top"] = NSLayoutConstraint(item: timePicker, attribute: .Top, relatedBy: .Equal, toItem: timeButton, attribute: .Bottom, multiplier: 1, constant: 0)
      nextButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: nextButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1.0, constant: (timePicker.frame.origin.y + timePicker.frame.height) - nextButton.frame.origin.y)
      
      self.view.addConstraint(dateTimeSectionConstraints["Bottom"]!)
      self.view.addConstraint(dateButtonConstraints["Top"]!)
      self.view.addConstraint(datePickerConstraints["Top"]!)
      self.view.addConstraint(timeButtonConstraints["Top"]!)
      self.view.addConstraint(timePickerConstraints["Top"]!)
      self.view.layoutIfNeeded()
   }
   
   func loadReviewSectionConstraints() {
      let viewsDict = ["reviewSectionButton":reviewSectionButton, "seekOfferLabel":seekOfferLabel, "tripLabel":tripLabel, "dateLabel":dateLabel, "timeLabel":timeLabel, "postRideButton":postRideButton, "ridePostedView":ridePostedView]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[reviewSectionButton(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferLabel(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tripLabel(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[dateLabel(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timeLabel(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[postRideButton(80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[ridePostedView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[reviewSectionButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[seekOfferLabel]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[tripLabel]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[dateLabel]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[timeLabel]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[postRideButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[ridePostedView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      reviewSectionConstraints["Top"] = NSLayoutConstraint(item: reviewSectionButton, attribute: .Top, relatedBy: .Equal, toItem: dateTimeSectionButton, attribute: .Bottom, multiplier: 1.0, constant: 1)
      reviewSectionConstraints["Bottom"] = NSLayoutConstraint(item: reviewSectionButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
      seekOfferLabelConstraints["Bottom"] = NSLayoutConstraint(item: seekOfferLabel, attribute: .Bottom, relatedBy: .Equal, toItem: tripLabel, attribute: .Top, multiplier: 1, constant: 0)
      tripLabelConstraints["Bottom"] = NSLayoutConstraint(item: tripLabel, attribute: .Bottom, relatedBy: .Equal, toItem: dateLabel, attribute: .Top, multiplier: 1, constant: 0)
      dateLabelConstraints["Bottom"] = NSLayoutConstraint(item: dateLabel, attribute: .Bottom, relatedBy: .Equal, toItem: timeLabel, attribute: .Top, multiplier: 1, constant: 0)
      postRideButtonConstraints["Top"] = NSLayoutConstraint(item: postRideButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
      postRideButtonConstraints["Bottom"] = NSLayoutConstraint(item: postRideButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
      
      self.view.addConstraint(reviewSectionConstraints["Bottom"]!)
      self.view.addConstraint(seekOfferLabelConstraints["Bottom"]!)
      self.view.addConstraint(tripLabelConstraints["Bottom"]!)
      self.view.addConstraint(dateLabelConstraints["Bottom"]!)
      self.view.addConstraint(postRideButtonConstraints["Top"]!)
      self.view.layoutIfNeeded()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.startingVC.viewDidLoad()
      self.endingVC.viewDidLoad()
      
      let defaults = NSUserDefaults.standardUserDefaults()
      if let savedId = defaults.stringForKey("PixieUserId") {
         post.userId = savedId.toInt()
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func segmentValueChanged(sender: AnyObject) {
      if startingSearchBar.hidden {
         self.view.removeConstraint(seekOfferSegmentConstraints["CenterY"]!)
         seekOfferSegmentConstraints["Top"] = NSLayoutConstraint(item: seekOfferSegment, attribute: .Top, relatedBy: .Equal, toItem: tripSectionButton, attribute: .Bottom, multiplier: 1, constant: (endingSearchBar.frame.origin.y - tripSectionButton.frame.origin.y - tripSectionButton.frame.height - seekOfferSegment.frame.height - startingSearchBar.frame.height)/3.0)
         
         UIView.animateWithDuration(0.2, animations: {
            self.view.addConstraint(self.seekOfferSegmentConstraints["Top"]!)
            self.seekOfferSegment.layoutIfNeeded()
            
            }, completion: {
               (value: Bool) in
               self.startingSearchBar.hidden = false
               self.startingSearchBar.isFirstResponder()
         })
      }
      let str = seekOfferSegment.selectedSegmentIndex == 0 ? "SEEKING" : "OFFERING"
      seekOfferLabel.attributedText = NSAttributedString(string: "\u{2015} "+str+" \u{2015}", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)!,NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
      post.setDriverEnum(seekOfferSegment.selectedSegmentIndex)
   }
   
   func selectedLocationInSearchBar() {
      if tripSectionButton.hidden {
         if activeSearchBar == self.startingSearchBar {
            startingSearchBarConstraints["Top"] = NSLayoutConstraint(item: startingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: seekOfferSegment, attribute: .Bottom, multiplier: 1, constant: (endingSearchBar.frame.origin.y - tripSectionButton.frame.origin.y - tripSectionButton.frame.height - seekOfferSegment.frame.height - startingSearchBar.frame.height)/3.0)
            self.view.removeConstraint(self.startingSearchBarConstraints["Search"]!)
            
            UIView.animateWithDuration(0.4, animations: {
               self.view.addConstraint(self.startingSearchBarConstraints["Top"]!)
               self.startingSearchBar.resignFirstResponder()
               self.seekOfferSegment.alpha = 1
               if !self.endingSearchBar.hidden {
                  self.endingSearchBar.alpha = 1
               }
               self.startingSearchBar.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  if self.endingSearchBar.hidden {
                     self.endingSearchBar.hidden = false
                  }
                  self.endingSearchBar.isFirstResponder()
                  self.view.removeConstraint(self.endingSearchBarConstraints["CenterY"]!)
                  self.activeSearchBar = self.endingSearchBar
                  
                  UIView.animateWithDuration(0.4, animations: {
                     self.view.addConstraint(self.endingSearchBarConstraints["Search"]!)
                     self.seekOfferSegment.alpha = 0
                     self.startingSearchBar.alpha = 0
                     self.endingSearchBar.layoutIfNeeded()
                     }, completion: {
                        (value: Bool) in
                        self.searchBarsVisible = false
                  })
            })
         } else if activeSearchBar == self.endingSearchBar {
            self.view.removeConstraint(self.endingSearchBarConstraints["Search"]!)
            
            UIView.animateWithDuration(0.4, animations: {
               self.view.addConstraint(self.endingSearchBarConstraints["CenterY"]!)
               self.endingSearchBar.resignFirstResponder()
               self.tripSectionButton.hidden = false
               self.seekOfferSegment.alpha = 1
               self.startingSearchBar.alpha = 1
               self.endingSearchBar.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.searchBarsVisible = true
                  if self.nextButton.hidden {
                     self.nextButton.hidden = false
                     self.view.addConstraint(self.nextButtonConstraints["Top"]!)
                     self.nextButton.layoutIfNeeded()
                  }
            })
         }
      } else {
         if activeSearchBar == startingSearchBar {
            self.view.removeConstraint(self.startingSearchBarConstraints["Search"]!)
            
            UIView.animateWithDuration(0.25, animations: {
               if self.endingSearchBar.hidden {
                  self.view.addConstraint(self.startingSearchBarConstraints["CenterY"]!)
               } else {
                  self.view.addConstraint(self.startingSearchBarConstraints["Top"]!)
               }
               if !self.tripSectionButton.hidden {
                  self.tripSectionButton.alpha = 1
               }
               self.seekOfferSegment.alpha = 1
               if !self.endingSearchBar.hidden {
                  self.endingSearchBar.alpha = 1
               }
               if !self.nextButton.hidden {
                  self.nextButton.alpha = 1
               }
               self.startingSearchBar.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  if self.endingSearchBar.text.isEmpty {
                     self.startingSearchBar.resignFirstResponder()
                     self.endingSearchBar.isFirstResponder()
                     self.activeSearchBar = self.endingSearchBar
                     self.view.removeConstraint(self.endingSearchBarConstraints["CenterY"]!)
                     
                     UIView.animateWithDuration(0.4, animations: {
                        self.view.addConstraint(self.endingSearchBarConstraints["Search"]!)
                        self.tripSectionButton.alpha = 0
                        self.seekOfferSegment.alpha = 0
                        self.startingSearchBar.alpha = 0
                        self.endingSearchBar.layoutIfNeeded()
                        }, completion: {
                           (value: Bool) in
                           self.searchBarsVisible = false
                     })
                  } else {
                     self.searchBarsVisible = true
                  }
            })
         }
         else if activeSearchBar == endingSearchBar {
            self.view.removeConstraint(self.endingSearchBarConstraints["Search"]!)
            
            UIView.animateWithDuration(0.25, animations: {
               self.view.addConstraint(self.endingSearchBarConstraints["CenterY"]!)
               if !self.tripSectionButton.hidden {
                  self.tripSectionButton.alpha = 1
               }
               self.seekOfferSegment.alpha = 1
               self.startingSearchBar.alpha = 1
               if !self.nextButton.hidden {
                  self.nextButton.alpha = 1
               }
               self.endingSearchBar.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.searchBarsVisible = true
            })
         }
      }
   }
   
   func reviewLocations(sender: UIButton) {
      if self.section == 1 || self.section == 3 {
         seekOfferSegment.hidden = false
         startingSearchBar.hidden = false
         endingSearchBar.hidden = false
         seekOfferSegment.alpha = 0
         startingSearchBar.alpha = 0
         endingSearchBar.alpha = 0
         
         if self.section == 1 {
            dateButton.hidden = true
            timeButton.hidden = true
            datePicker.alpha = 0
            timePicker.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
               
               self.seekOfferSegment.alpha = 1
               self.startingSearchBar.alpha = 1
               self.endingSearchBar.alpha = 1
               
               self.view.removeConstraint(self.dateTimeSectionConstraints["Top"]!)
               if (self.reviewSectionButton.hidden) {
                  self.view.addConstraint(self.dateTimeSectionConstraints["Bottom"]!)
               } else {
                  self.view.addConstraint(self.reviewSectionConstraints["Top"]!)
               }
               
               if !self.datePicker.hidden || !self.timePicker.hidden {
                  self.view.removeConstraint(self.nextButtonConstraints["TopExpanded"]!)
                  self.view.addConstraint(self.nextButtonConstraints["Top"]!)
                  
                  if !self.datePicker.hidden {
                     self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
                     self.view.addConstraint(self.timeButtonConstraints["Top"]!)
                  }
               }
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 0
                  if !self.datePicker.hidden {
                     self.datePicker.hidden = true
                  }
                  if !self.timePicker.hidden {
                     self.timePicker.hidden = true
                  }
            })
         } else if self.section == 3 {
            seekOfferLabel.hidden = true
            tripLabel.hidden = true
            dateLabel.hidden = true
            timeLabel.hidden = true
            nextButton.hidden = false
            nextButton.alpha = 0
            
            UIView.animateWithDuration(0.2, animations: {
               
               self.seekOfferSegment.alpha = 1
               self.startingSearchBar.alpha = 1
               self.endingSearchBar.alpha = 1
               self.nextButton.alpha = 1
               
               self.view.removeConstraint(self.dateTimeSectionConstraints["Top"]!)
               self.view.addConstraint(self.reviewSectionConstraints["Bottom"]!)
               self.view.removeConstraint(self.postRideButtonConstraints["Bottom"]!)
               self.view.addConstraint(self.postRideButtonConstraints["Top"]!)
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 0
                  //self.nextButton.hidden = false
            })
         }
      }
   }
   
   func reviewDateTime(sender: UIButton) {
      if self.section == 0 && !locationsEntered() {
         return
      }
      startingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      endingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      
      if self.section == 0 || self.section == 3 {
         dateButton.hidden = false
         timeButton.hidden = false
         self.dateButton.alpha = 0
         self.timeButton.alpha = 0
         
         if self.section == 0 {
            seekOfferSegment.hidden = true
            startingSearchBar.hidden = true
            endingSearchBar.hidden = true
            UIView.animateWithDuration(0.2, animations: {
               
               self.dateButton.alpha = 1
               self.timeButton.alpha = 1
               
               if (self.reviewSectionButton.hidden) {
                  self.view.removeConstraint(self.dateTimeSectionConstraints["Bottom"]!)
               } else {
                  self.view.removeConstraint(self.reviewSectionConstraints["Top"]!)
               }
               self.view.addConstraint(self.dateTimeSectionConstraints["Top"]!)
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 1
            })
         } else if (self.section == 3) {
            seekOfferLabel.hidden = true
            tripLabel.hidden = true
            dateLabel.hidden = true
            timeLabel.hidden = true
            nextButton.hidden = false
            nextButton.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
               
               self.dateButton.alpha = 1
               self.timeButton.alpha = 1
               self.nextButton.alpha = 1
               
               self.view.removeConstraint(self.reviewSectionConstraints["Top"]!)
               self.view.addConstraint(self.reviewSectionConstraints["Bottom"]!)
               self.view.removeConstraint(self.postRideButtonConstraints["Bottom"]!)
               self.view.addConstraint(self.postRideButtonConstraints["Top"]!)
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 1
            })
         }
      }
   }
   
   func reviewPost(sender: UIButton) {
      if self.section == 0 && !locationsEntered() {
         return
      }
      startingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      endingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      
      if self.section == 0 || self.section == 1 {
         nextButton.hidden = true
         seekOfferLabel.hidden = false
         tripLabel.hidden = false
         dateLabel.hidden = false
         timeLabel.hidden = false
         seekOfferLabel.alpha = 0
         tripLabel.alpha = 0
         dateLabel.alpha = 0
         timeLabel.alpha = 0
         postRideButton.alpha = 0
         
         if self.section == 0 {
            seekOfferSegment.hidden = true
            startingSearchBar.hidden = true
            endingSearchBar.hidden = true
            UIView.animateWithDuration(0.2, animations: {
               
               self.seekOfferLabel.alpha = 1
               self.tripLabel.alpha = 1
               self.dateLabel.alpha = 1
               self.timeLabel.alpha = 1
               self.postRideButton.alpha = 1
               
               self.view.removeConstraint(self.reviewSectionConstraints["Bottom"]!)
               self.view.addConstraint(self.dateTimeSectionConstraints["Top"]!)
               self.view.removeConstraint(self.postRideButtonConstraints["Top"]!)
               self.view.addConstraint(self.postRideButtonConstraints["Bottom"]!)
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 3
            })
         } else if (self.section == 1) {
            dateButton.hidden = true
            timeButton.hidden = true
            datePicker.alpha = 0
            timePicker.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
               
               if !self.datePicker.hidden || !self.timePicker.hidden {
                  self.view.removeConstraint(self.nextButtonConstraints["TopExpanded"]!)
                  self.view.addConstraint(self.nextButtonConstraints["Top"]!)
                  
                  if !self.datePicker.hidden {
                     self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
                     self.view.addConstraint(self.timeButtonConstraints["Top"]!)
                  }
               }
               
               self.seekOfferLabel.alpha = 1
               self.tripLabel.alpha = 1
               self.dateLabel.alpha = 1
               self.timeLabel.alpha = 1
               self.postRideButton.alpha = 1
               
               self.view.removeConstraint(self.reviewSectionConstraints["Bottom"]!)
               self.view.addConstraint(self.reviewSectionConstraints["Top"]!)
               self.view.removeConstraint(self.postRideButtonConstraints["Top"]!)
               self.view.addConstraint(self.postRideButtonConstraints["Bottom"]!)
               self.view.layoutIfNeeded()
               }, completion: {
                  (value: Bool) in
                  self.section = 3
                  if !self.datePicker.hidden {
                     self.datePicker.hidden = true
                  }
                  if !self.timePicker.hidden {
                     self.timePicker.hidden = true
                  }
            })
         }
      }
   }
   
   func nextButtonPressed(sender: UIButton) {
      
      if section == 0 {
         if !locationsEntered() {
            return
         }
         startingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
         endingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
         
         self.setDateTimeString()
         seekOfferSegment.hidden = true
         startingSearchBar.hidden = true
         endingSearchBar.hidden = true
         dateButton.hidden = false
         timeButton.hidden = false
         dateButton.alpha = 0
         timeButton.alpha = 0
         if dateTimeSectionButton.hidden {
            dateTimeSectionButton.hidden = false
            dateTimeSectionButton.alpha = 0
         }
         
         UIView.animateWithDuration(0.2, animations: {
            
            self.dateTimeSectionButton.alpha = 1
            self.dateButton.alpha = 1
            self.timeButton.alpha = 1
            
            if self.reviewSectionButton.hidden {
               self.view.removeConstraint(self.dateTimeSectionConstraints["Bottom"]!)
            } else {
               self.view.removeConstraint(self.reviewSectionConstraints["Top"]!)
            }
            self.view.addConstraint(self.dateTimeSectionConstraints["Top"]!)
            self.view.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.section = 1
         })
      } else if section == 1 {
         if self.reviewSectionButton.hidden {
            self.reviewSectionButton.hidden = false
            let spacing = self.view.frame.size.height - postRideButton.frame.size.height - tripSectionButton.frame.origin.y - tripSectionButton.frame.size.height*3 - 2 - seekOfferLabel.frame.size.height - tripLabel.frame.size.height - dateLabel.frame.size.height - timeLabel.frame.size.height
            timeLabelConstraints["Bottom"] = NSLayoutConstraint(item: timeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -(spacing/3*2 + postRideButton.frame.size.height))
            self.view.addConstraint(timeLabelConstraints["Bottom"]!)
            self.view.layoutIfNeeded()
         }
         
         self.seekOfferLabel.hidden = false
         self.tripLabel.hidden = false
         self.dateLabel.hidden = false
         self.timeLabel.hidden = false
         self.dateButton.hidden = true
         self.timeButton.hidden = true
         self.nextButton.hidden = true
         self.datePicker.alpha = 0
         self.timePicker.alpha = 0
         self.seekOfferLabel.alpha = 0
         self.tripLabel.alpha = 0
         self.dateLabel.alpha = 0
         self.timeLabel.alpha = 0
         self.reviewSectionButton.alpha = 0
         self.postRideButton.alpha = 0
         
         UIView.animateWithDuration(0.2, animations: {
            
            self.reviewSectionButton.alpha = 1
            self.postRideButton.alpha = 1
            self.seekOfferLabel.alpha = 1
            self.tripLabel.alpha = 1
            self.dateLabel.alpha = 1
            self.timeLabel.alpha = 1
            
            self.view.removeConstraint(self.reviewSectionConstraints["Bottom"]!)
            self.view.addConstraint(self.reviewSectionConstraints["Top"]!)
            self.view.removeConstraint(self.postRideButtonConstraints["Top"]!)
            self.view.addConstraint(self.postRideButtonConstraints["Bottom"]!)
            self.view.layoutIfNeeded()
            
            }, completion: {
               (value: Bool) in
               self.section = 3
               
               if !self.datePicker.hidden || !self.timePicker.hidden {
                  self.view.removeConstraint(self.nextButtonConstraints["TopExpanded"]!)
                  self.view.addConstraint(self.nextButtonConstraints["Top"]!)
                  
                  if !self.datePicker.hidden {
                     self.datePicker.hidden = true
                     self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
                     self.view.addConstraint(self.timeButtonConstraints["Top"]!)
                  }
                  if !self.timePicker.hidden {
                     self.timePicker.hidden = true
                  }
                  self.view.layoutIfNeeded()
               }
         })
      }
   }
   
   func setDateTimeString() {
      let tempDate = self.dateButton.currentAttributedTitle?.string
      let tempTime = self.timeButton.currentAttributedTitle?.string
      let range = NSMakeRange(count(tempDate!)-2, 2)
      
      var tripString = NSMutableAttributedString(string: tempDate! + " " + tempTime!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 22.0)!])
      dateTimeSectionButton.setAttributedTitle(tripString, forState: .Normal)
      dateTimeSectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      
      let currentDateArr = tempDate!.componentsSeparatedByString(" ")
      var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
      date.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 30)!, range: NSMakeRange(count(currentDateArr[0])-1, 1))
      dateLabel.attributedText = date
      
      let currentTimeArr = tempTime!.componentsSeparatedByString(" ")
      timeLabel.attributedText = createAttributedString(currentTimeArr[0], str2: currentTimeArr.count == 1 ? "" : currentTimeArr[1], color: UIColor.whiteColor())
   }
   
   func selectDate(button: UIButton) {
      if datePicker.hidden {
         self.datePicker.hidden = false
         self.datePicker.alpha = 0
         
         UIView.animateWithDuration(0.2, animations: {
            self.datePicker.alpha = 1
            
            if self.timePicker.hidden {
               self.view.removeConstraint(self.nextButtonConstraints["Top"]!)
               self.view.addConstraint(self.nextButtonConstraints["TopExpanded"]!)
            } else {
               self.timePicker.alpha = 0
            }
            
            self.view.removeConstraint(self.timeButtonConstraints["Top"]!)
            self.view.addConstraint(self.timeButtonConstraints["TopExpanded"]!)
            self.view.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               if !self.timePicker.hidden {
                  self.timePicker.hidden = true
               }
         })
      } else {
         UIView.animateWithDuration(0.2, animations: {
            self.datePicker.alpha = 0
            self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
            self.view.addConstraint(self.timeButtonConstraints["Top"]!)
            self.view.removeConstraint(self.nextButtonConstraints["TopExpanded"]!)
            self.view.addConstraint(self.nextButtonConstraints["Top"]!)
            self.view.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.datePicker.hidden = true
         })
      }
   }
   
   func selectTime(button: UIButton) {
      if timePicker.hidden {
         self.timePicker.hidden = false
         self.timePicker.alpha = 0
         
         UIView.animateWithDuration(0.2, animations: {
            self.timePicker.alpha = 1
            
            if self.datePicker.hidden {
               self.view.removeConstraint(self.nextButtonConstraints["Top"]!)
               self.view.addConstraint(self.nextButtonConstraints["TopExpanded"]!)
            } else {
               self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
               self.view.addConstraint(self.timeButtonConstraints["Top"]!)
               self.datePicker.alpha = 0
            }
            self.view.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               if !self.datePicker.hidden {
                  self.datePicker.hidden = true
               }
         })
      } else {
         UIView.animateWithDuration(0.2, animations: {
            self.timePicker.alpha = 0
            self.view.removeConstraint(self.nextButtonConstraints["TopExpanded"]!)
            self.view.addConstraint(self.nextButtonConstraints["Top"]!)
            self.view.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.setDateTimeString()
               self.timePicker.hidden = true
         })
      }
   }
   
   func getCurrentDates() {
      let today = NSDate()
      var date: NSDate!
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEEE, MMMM dd"
      var dateString: String
      
      for i in 0 ..< 30 {
         date = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitDay,
            value: i,
            toDate: today,
            options: NSCalendarOptions(0))
         
         dateString = dateFormatter.stringFromDate(date);
         var start = advance(dateString.startIndex, count(dateString) - 2)
         var end = advance(dateString.startIndex, count(dateString) - 1)
         var day_of_month = dateString.substringFromIndex(start).toInt()!
         
         if day_of_month < 10 {
            dateString = dateString.stringByReplacingCharactersInRange(Range<String.Index>(start: start,end: end), withString: "")
         }
         
         currentDates.append(dateString)
      }
   }
   
   //MARK: - Delegates and data sources
   //MARK: Data Sources
   func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
      if pickerView == datePicker {
         return 1
      } else {
         return 3
      }
   }
   
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      if pickerView == datePicker {
         return currentDates.count
      } else {
         if (component == 0) {
            return hours.count
         } else  if (component == 1) {
            return minutes.count
         } else {
            return 3
         }
      }
   }
   
   //MARK: Delegates
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if pickerView == datePicker {
         let currentDateArr = currentDates[row].componentsSeparatedByString(" ")
         var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
         dateButton.setAttributedTitle(date, forState: .Normal)
         post.dayFormatStr = post.getDayFormatStr(currentDates[row])
      } else {
         if component == 0 {
            if row == 0 {
               timePicker.selectRow(0, inComponent: 1, animated: true)
               timePicker.selectRow(0, inComponent: 2, animated: true)
            } else {
               if timePicker.selectedRowInComponent(1) == 0 {
                  timePicker.selectRow(1, inComponent: 1, animated: true)
               }
               if timePicker.selectedRowInComponent(2) == 0 {
                  timePicker.selectRow(1, inComponent: 2, animated: true)
               }
            }
         } else if component == 1 {
            if row == 0 {
               timePicker.selectRow(0, inComponent: 0, animated: true)
               timePicker.selectRow(0, inComponent: 2, animated: true)
            } else {
               if timePicker.selectedRowInComponent(0) == 0 {
                  timePicker.selectRow(1, inComponent: 0, animated: true)
               }
               if timePicker.selectedRowInComponent(2) == 0 {
                  timePicker.selectRow(1, inComponent: 2, animated: true)
               }
            }
         } else {
            if row == 0 {
               timePicker.selectRow(0, inComponent: 0, animated: true)
               timePicker.selectRow(0, inComponent: 1, animated: true)
            } else {
               if timePicker.selectedRowInComponent(0) == 0 {
                  timePicker.selectRow(1, inComponent: 0, animated: true)
               }
               if timePicker.selectedRowInComponent(1) == 0 {
                  timePicker.selectRow(1, inComponent: 1, animated: true)
               }
            }
         }
         var selectedTime = hours[timePicker.selectedRowInComponent(0)]
         if timePicker.selectedRowInComponent(0) != 0 {
            selectedTime += ":\(minutes[timePicker.selectedRowInComponent(1)])"
         }
         let selectedAMPM = ampm[timePicker.selectedRowInComponent(2)]
         timeButton.setAttributedTitle(createAttributedString(selectedTime, str2: selectedAMPM, color: UIColor.whiteColor()), forState: .Normal)
         post.timeFormatStr = post.getTimeFormatStr("\(selectedTime) \(selectedAMPM)")
      }
      setDateTimeString()
   }
   
   func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
      if pickerView == datePicker {
         return self.view.frame.width
      } else {
         return 90.0
      }
   }
   
   func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
      var pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.whiteColor()
      pickerLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
      pickerLabel.textAlignment = NSTextAlignment.Center
      
      if pickerView == datePicker {
         pickerLabel.attributedText = NSMutableAttributedString(string: currentDates[row])
      } else {
         if (component == 0) {
            pickerLabel.text = hours[row]
         } else if (component == 1) {
            pickerLabel.text = minutes[row]
         } else {
            pickerLabel.text = ampm[row]
         }
      }
      return pickerLabel
   }
   
   func createAttributedString(str1: String, str2: String, color: UIColor) -> NSMutableAttributedString {
      var myString = NSMutableAttributedString(string: str1 + " " + str2)
      myString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 30)!, range: NSMakeRange(0, count(str1)))
      myString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 30)!, range: NSMakeRange(count(str1)+1, count(str2)))
      myString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, myString.length))
      return myString
      
   }
   
   func locationsEntered() -> Bool {
      var ret: Bool = true
      
      if startingSearchBar.text.isEmpty {
         startingSearchBar.layer.borderColor = UIColor.redColor().CGColor
         ret = false
      }
      if endingSearchBar.text.isEmpty {
         endingSearchBar.layer.borderColor = UIColor.redColor().CGColor
         ret = false
      }
      if startingSearchBar.text == endingSearchBar.text {
         startingSearchBar.layer.borderColor = UIColor.redColor().CGColor
         endingSearchBar.layer.borderColor = UIColor.redColor().CGColor
         ret = false
      }
      
      return ret
   }
   
   func postRide(sender: UIButton) {
      let urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/posts";
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
      var session = NSURLSession.sharedSession();
      request.HTTPMethod = "POST"
      var err: NSError?
      
      var reqText = ["start_name": post.start.name, "start_lat": post.start.latitude, "start_lon": post.start.longitude, "end_name": post.end.name, "end_lat": post.end.latitude, "end_lon": post.end.longitude, "day": post.dayFormatStr, "driver_enum": post.driverEnum, "time": post.timeFormatStr, "userId": post.userId]
      
      println("\nreqText...\(reqText)")
      
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
         var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
         if(err != nil) {
            println(err!.localizedDescription)
         }
         else {
            println("strData...\n\(strData)")
         }
//         if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//            println("postRide json...\n\(json)")
//         }
      })
      
      task.resume();
      
      UIView.animateWithDuration(0.25, animations: {
         self.ridePostedView.alpha = 1
         }, completion: {
            (value: Bool) in
            self.delay(0.5) {
               self.performSegueWithIdentifier("unwindToSearchView", sender: self)
            }
      })
   }
   
   func goBack(sender: UIButton) {
      self.performSegueWithIdentifier("unwindToSearchView", sender: self)
   }
   
   func swipeBack(sender:UISwipeGestureRecognizer) {
      self.performSegueWithIdentifier("unwindToSearchView", sender: self)
   }
   
   func delay(delay:Double, closure:()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   // MARK: - GooglePlacesAutocompleteContainer (UITableViewDataSource / UITableViewDelegate)
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return activeSearchBar == startingSearchBar ? startingVC.places.count : endingVC.places.count
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      var cell: ACTableViewCell
      if (activeSearchBar == startingSearchBar) {
         cell = self.startingTableView.dequeueReusableCellWithIdentifier("cell") as! ACTableViewCell
      } else {
         cell = self.endingTableView.dequeueReusableCellWithIdentifier("cell") as! ACTableViewCell
      }
      let place = activeSearchBar == startingSearchBar ? startingVC.places[indexPath.row] : endingVC.places[indexPath.row]
      
      cell.placeLabel.text = place.description
      
      return cell
   }
   
   func setTripInfo(searchBar: UISearchBar, city:String, state:String) {
      searchBar.text = city + ", " + state
      self.tripSectionButton.setTitle(self.startingSearchBar.text + " \u{2192} " + self.endingSearchBar.text, forState: .Normal)
      self.tripLabel.text = self.startingSearchBar.text + " \u{2192} " + self.endingSearchBar.text
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if (activeSearchBar == startingSearchBar) {
         startingVC.delegate?.placeSelected?(startingVC.places[indexPath.row])
         let place = startingVC.places[indexPath.row]
         place.getDetails { details in
            self.setTripInfo(self.startingSearchBar, city: details.city, state: details.state)
            self.post.start = Location(name: "\(details.city), \(details.state)", lat: details.latitude, long: details.longitude)
         }
         startingTableView.hidden = true
         if endingSearchBar.alpha == 0 {
            endingSearchBar.alpha = 1
         }
         startingSearchBar.resignFirstResponder()
         if endingSearchBar.text.isEmpty {
            endingSearchBar.becomeFirstResponder()
         }
      }
      else {
         endingVC.delegate?.placeSelected?(endingVC.places[indexPath.row])
         let place = endingVC.places[indexPath.row]
         place.getDetails { details in
            self.setTripInfo(self.endingSearchBar, city: details.city, state: details.state)
            self.post.end = Location(name: "\(details.city), \(details.state)", lat: details.latitude, long: details.longitude)
         }
         endingTableView.hidden = true
         endingSearchBar.resignFirstResponder()
      }
      if nextButton.alpha == 0 {
         nextButton.alpha = 1
      }
      
      
      dispatch_async(dispatch_get_main_queue(),{
         self.selectedLocationInSearchBar()
      });
   }
   
   // handles hiding keyboard when user touches outside of keyboard
   override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      self.view.endEditing(true)
      
      if activeSearchBar == startingSearchBar && !searchBarsVisible {
         self.view.removeConstraint(self.startingSearchBarConstraints["Search"]!)
         
         UIView.animateWithDuration(0.25, animations: {
            if self.endingSearchBar.hidden {
               self.view.addConstraint(self.startingSearchBarConstraints["CenterY"]!)
            } else {
               self.view.addConstraint(self.startingSearchBarConstraints["Top"]!)
            }
            if !self.tripSectionButton.hidden {
               self.tripSectionButton.alpha = 1
            }
            self.seekOfferSegment.alpha = 1
            if !self.endingSearchBar.hidden {
               self.endingSearchBar.alpha = 1
            }
            if !self.nextButton.hidden {
               self.nextButton.alpha = 1
            }
            self.startingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.searchBarsVisible = true
         })
         self.startingSearchBar.resignFirstResponder()
      }
      else if activeSearchBar == endingSearchBar && !searchBarsVisible {
         self.view.removeConstraint(self.endingSearchBarConstraints["Search"]!)
         
         UIView.animateWithDuration(0.25, animations: {
            self.view.addConstraint(self.endingSearchBarConstraints["CenterY"]!)
            if !self.tripSectionButton.hidden {
               self.tripSectionButton.alpha = 1
            }
            self.seekOfferSegment.alpha = 1
            self.startingSearchBar.alpha = 1
            if !self.nextButton.hidden {
               self.nextButton.alpha = 1
            }
            self.endingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.searchBarsVisible = true
         })
         self.endingSearchBar.resignFirstResponder()
      }
   }
   
   // MARK: - GooglePlacesAutocompleteContainer (UISearchBarDelegate)
   
   func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
      if searchBarsVisible {
         self.activeSearchBar = searchBar
      }
      
      if searchBar == startingSearchBar && searchBarsVisible {
         self.searchBarsVisible = false
         if self.endingSearchBar.hidden {
            self.view.removeConstraint(self.startingSearchBarConstraints["CenterY"]!)
         } else {
            self.view.removeConstraint(self.startingSearchBarConstraints["Top"]!)
         }
         
         UIView.animateWithDuration(0.25, animations: {
            self.view.addConstraint(self.startingSearchBarConstraints["Search"]!)
            self.seekOfferSegment.alpha = 0
            self.endingSearchBar.alpha = 0
            if !self.tripSectionButton.hidden {
               self.tripSectionButton.alpha = 0
            }
            if !self.nextButton.hidden {
               self.nextButton.alpha = 0
            }
            self.startingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
         })
      }
      else if searchBar == endingSearchBar && searchBarsVisible {
         self.searchBarsVisible = false
         self.view.removeConstraint(self.endingSearchBarConstraints["CenterY"]!)

         UIView.animateWithDuration(0.25, animations: {
            self.view.addConstraint(self.endingSearchBarConstraints["Search"]!)
            self.seekOfferSegment.alpha = 0
            self.startingSearchBar.alpha = 0
            if !self.tripSectionButton.hidden {
               self.tripSectionButton.alpha = 0
            }
            if !self.nextButton.hidden {
               self.nextButton.alpha = 0
            }
            self.endingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
         })
      }
   }
   
   func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
      if (searchText == "") {
         if (self.activeSearchBar == startingSearchBar) {
            startingVC.places = []
            startingTableView.hidden = true
         } else {
            endingVC.places = []
            endingTableView.hidden = true
         }
      } else {
         getPlaces(searchText)
      }
   }
   
   /**
   Call the Google Places API and update the view with results.
   
   :param: searchString The search query
   */
   func getPlaces(searchString: String) {
      //      println("in getPlaces with \(searchString)")
      
      if (self.activeSearchBar == startingSearchBar) {
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
                  self.refreshUI()
                  self.endingSearchBar.alpha = 0
                  self.nextButton.alpha = 0
                  self.startingTableView.hidden = false
                  self.startingVC.delegate?.placesFound?(self.startingVC.places)
               }
         }
      } else {
         GooglePlacesRequestHelpers.doRequest(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            params: [
               "input": searchString,
               "types": endingVC.placeType.description,
               "key": endingVC.apiKey ?? ""
            ]
            ) { json in
               if let predictions = json["predictions"] as? Array<[String: AnyObject]> {
                  self.endingVC.places = predictions.map { (prediction: [String: AnyObject]) -> Place in
                     return Place(prediction: prediction, apiKey: self.endingVC.apiKey)
                  }
                  
                  self.reloadInputViews()
                  self.refreshUI()
                  self.nextButton.alpha = 0
                  self.endingTableView.hidden = false
                  self.endingVC.delegate?.placesFound?(self.endingVC.places)
               }
         }
      }
   }
   
   func refreshUI() {
      dispatch_async(dispatch_get_main_queue(),{
         if (self.activeSearchBar == self.startingSearchBar) {
            self.startingTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
         } else {
            self.endingTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
         }
      });
   }
}

extension PostRideViewController: GooglePlacesAutocompleteDelegate {
   func placeSelected(place: Place) {
      place.getDetails { details in
         println(details)
      }
   }
}