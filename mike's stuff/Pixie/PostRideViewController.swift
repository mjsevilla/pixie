//
//  PostRideViewController.swift
//  PostRide
//
//  Created by Nicole (damn straight) on wouldn't/u/lyke2know.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class PostRideViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   
   var blurEffectView : UIVisualEffectView!
   var backButton: UIButton!
   var tripSectionButton: UIButton!
   var seekOfferSegment: UISegmentedControl!
   var startingLocation: UITextField!
   var endingLocation: UITextField!
   
   var dateTimeSectionButton: UIButton!
   var dateButton: UIButton!
   var datePicker: UIPickerView!
   var timeButton: UIButton!
   var timePicker: UIPickerView!
   var currentDates: [String] = []
   var times: [String] = []
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
   var startingLocationConstraints = [String: NSLayoutConstraint]()
   var endingLocationConstraints = [String: NSLayoutConstraint]()
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
      
      loadTripSectionView()
      loadDateTimeSectionView()
      loadReviewSectionView()
      
      nextButton = UIButton()
      let nextString = NSAttributedString(string: "NEXT", attributes: [NSForegroundColorAttributeName: UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0), NSFontAttributeName: UIFont(name: "Syncopate-Regular", size: 20.0)!])
      nextButton.setAttributedTitle(nextString, forState: .Normal)
      nextButton.sizeToFit()
      nextButton.hidden = true
      nextButton.addTarget(self, action: "nextButtonPressed:", forControlEvents: .TouchUpInside)
      nextButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(nextButton)
      
      backButton = UIButton(frame: CGRectMake(10, 28, 22, 22))
      UIGraphicsBeginImageContext(backButton.frame.size)
      let cntx = UIGraphicsGetCurrentContext()
      CGContextSetStrokeColorWithColor(cntx, UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0).CGColor)
      CGContextSetLineWidth(cntx, 1.0)
      CGContextMoveToPoint(cntx, backButton.frame.width/2.0, 0)
      CGContextAddLineToPoint(cntx, 0, backButton.frame.height/2.0)
      CGContextAddLineToPoint(cntx, backButton.frame.width/2.0, backButton.frame.height)
      CGContextStrokePath(cntx)
      let arrow = UIImageView(frame: CGRectMake(0, 0, backButton.frame.width, backButton.frame.height))
      arrow.image = UIGraphicsGetImageFromCurrentImageContext()
      backButton.addSubview(arrow)
      UIGraphicsEndImageContext()
      backButton.userInteractionEnabled = true
      backButton.addTarget(self, action: "goBack:", forControlEvents: .TouchUpInside)
      view.addSubview(backButton)
      
      loadTripSectionContraints()
      loadDateTimeSectionContraints()
      loadReviewSectionConstraints()
   }
   
   func loadTripSectionView() {
      tripSectionButton = UIButton()
      tripSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha: 0.8)
      tripSectionButton.addTarget(self, action: "reviewLocations:", forControlEvents: .TouchUpInside)
      tripSectionButton.hidden = true
      tripSectionButton.titleLabel?.textAlignment = .Center
      tripSectionButton.titleLabel?.numberOfLines = 1
      tripSectionButton.titleLabel?.adjustsFontSizeToFitWidth = true
      tripSectionButton.titleLabel?.lineBreakMode = .ByClipping;
      tripSectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(tripSectionButton)
      
      seekOfferSegment = UISegmentedControl()
      seekOfferSegment.insertSegmentWithTitle("SEEKING", atIndex: 0, animated: false)
      seekOfferSegment.insertSegmentWithTitle("OFFERING", atIndex: 1, animated: false)
      var attr = NSDictionary(object: UIFont(name: "Syncopate-Regular", size: 16.0)!, forKey: NSFontAttributeName)
      seekOfferSegment.setTitleTextAttributes(attr, forState: .Normal)
      seekOfferSegment.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
      seekOfferSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
      seekOfferSegment.tintColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0)
      
      view.addSubview(seekOfferSegment)
      
      let leftPaddingViewStart = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
      leftPaddingViewStart.backgroundColor = UIColor.clearColor()
      let leftPaddingViewEnd = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
      leftPaddingViewEnd.backgroundColor = UIColor.clearColor()
      
      startingLocation = UITextField()
      startingLocation.leftView = leftPaddingViewStart
      startingLocation.leftViewMode = .Always
      startingLocation.backgroundColor = UIColor.clearColor()
      startingLocation.textColor = UIColor.whiteColor()
      startingLocation.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      startingLocation.attributedPlaceholder = NSAttributedString(string:" Where are you starting from?",
         attributes:[NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16.0)!])
      startingLocation.layer.cornerRadius = 8.0
      startingLocation.layer.masksToBounds = true
      startingLocation.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0).CGColor
      startingLocation.layer.borderWidth = 1.0
      startingLocation.delegate = self
      startingLocation.hidden = true
      startingLocation.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(startingLocation)
      
      endingLocation = UITextField()
      endingLocation.leftView = leftPaddingViewEnd
      endingLocation.leftViewMode = .Always
      endingLocation.backgroundColor = UIColor.clearColor()
      endingLocation.textColor = UIColor.whiteColor()
      endingLocation.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      endingLocation.attributedPlaceholder = NSAttributedString(string:" Where do you want to go?",
         attributes:[NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16.0)!])
      endingLocation.layer.cornerRadius = 8.0
      endingLocation.layer.masksToBounds = true
      endingLocation.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha:1.0).CGColor
      endingLocation.layer.borderWidth = 1.0
      endingLocation.delegate = self
      endingLocation.hidden = true
      endingLocation.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(endingLocation)
   }
   
   func loadDateTimeSectionView() {
      getCurrentDates()
      getTimes()
      
      dateTimeSectionButton = UIButton()
      dateTimeSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha: 0.8)
      dateTimeSectionButton.addTarget(self, action: "reviewDateTime:", forControlEvents: .TouchUpInside)
      dateTimeSectionButton.titleLabel?.textAlignment = .Center
      dateTimeSectionButton.titleLabel?.numberOfLines = 1
      dateTimeSectionButton.titleLabel?.adjustsFontSizeToFitWidth = true
      dateTimeSectionButton.titleLabel?.lineBreakMode = .ByClipping;
      dateTimeSectionButton.hidden = true
      dateTimeSectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(dateTimeSectionButton)
      
      dateButton = UIButton()
      dateButton.addTarget(self, action: "selectDate:", forControlEvents: UIControlEvents.TouchUpInside)
      let currentDateArr = currentDates[0].componentsSeparatedByString(" ")
      var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
      date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(countElements(date.string)-2, 2))
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
      timeButton.setAttributedTitle(NSAttributedString(string: times[0], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30.0)!]), forState: .Normal)
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
      reviewSectionButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha: 0.8)
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
      postRideButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.83, alpha: 1.0)
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
      let viewsDict = ["nextButton":nextButton, "tripSectionButton":tripSectionButton, "seekOfferSegment":seekOfferSegment, "startingLocation":startingLocation, "endingLocation":endingLocation, "blurEffectView":blurEffectView]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[blurEffectView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tripSectionButton(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startingLocation(30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[endingLocation(30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[blurEffectView]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tripSectionButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nextButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      tripSectionConstraints["Top"] = NSLayoutConstraint(item: tripSectionButton, attribute: .Top, relatedBy: .Equal, toItem: backButton, attribute: .Bottom, multiplier: 1, constant: 15.0)
      seekOfferSegmentConstraints["CenterY"] = NSLayoutConstraint(item: seekOfferSegment, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      startingLocationConstraints["CenterY"] = NSLayoutConstraint(item: startingLocation, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      endingLocationConstraints["CenterY"] = NSLayoutConstraint(item: endingLocation, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      nextButtonConstraints["Top"] = NSLayoutConstraint(item: self.nextButton, attribute: .Top, relatedBy: .Equal, toItem: self.endingLocation, attribute: .Bottom, multiplier: 1.0, constant: 50)
      
      
      self.view.addConstraint(tripSectionConstraints["Top"]!)
      self.view.addConstraint(seekOfferSegmentConstraints["CenterY"]!)
      self.view.addConstraint(startingLocationConstraints["CenterY"]!)
      self.view.addConstraint(endingLocationConstraints["CenterY"]!)
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
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[tripLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeLabel]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
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
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func segmentValueChanged(sender: AnyObject) {
      if startingLocation.hidden {
         self.view.removeConstraint(seekOfferSegmentConstraints["CenterY"]!)
         seekOfferSegmentConstraints["Top"] = NSLayoutConstraint(item: seekOfferSegment, attribute: .Top, relatedBy: .Equal, toItem: tripSectionButton, attribute: .Bottom, multiplier: 1, constant: (endingLocation.frame.origin.y - tripSectionButton.frame.origin.y - tripSectionButton.frame.height - seekOfferSegment.frame.height - startingLocation.frame.height)/3.0)
         
         UIView.animateWithDuration(0.2, animations: {
            self.view.addConstraint(self.seekOfferSegmentConstraints["Top"]!)
            self.seekOfferSegment.layoutIfNeeded()
            
            }, completion: {
               (value: Bool) in
               self.startingLocation.hidden = false
               self.startingLocation.isFirstResponder()
         })
      }
      let str = seekOfferSegment.selectedSegmentIndex == 0 ? "SEEKING" : "OFFERING"
      seekOfferLabel.attributedText = NSAttributedString(string: "\u{2015} "+str+" \u{2015}", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)!,NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
   }
   
   func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
      if textField == self.startingLocation {
         var txtAfterUpdate:NSString = self.startingLocation.text as NSString
         txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
         setTripString(txtAfterUpdate, end: endingLocation.text)
      } else {
         var txtAfterUpdate:NSString = self.endingLocation.text as NSString
         txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
         setTripString(startingLocation.text, end: txtAfterUpdate)
      }
      
      return true
   }
   
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      if tripSectionButton.hidden {
         if textField == self.startingLocation {
            startingLocationConstraints["Top"] = NSLayoutConstraint(item: startingLocation, attribute: .Top, relatedBy: .Equal, toItem: seekOfferSegment, attribute: .Bottom, multiplier: 1, constant: (endingLocation.frame.origin.y - tripSectionButton.frame.origin.y - tripSectionButton.frame.height - seekOfferSegment.frame.height - startingLocation.frame.height)/3.0)
            
            UIView.animateWithDuration(0.2, animations: {
               self.view.removeConstraint(self.startingLocationConstraints["CenterY"]!)
               self.view.addConstraint(self.startingLocationConstraints["Top"]!)
               self.startingLocation.layoutIfNeeded()
               
               }, completion: {
                  (value: Bool) in
                  if self.endingLocation.hidden {
                     self.endingLocation.hidden = false
                     self.endingLocation.isFirstResponder()
                  }
            })
         } else if textField == self.endingLocation {
            UIView.animateWithDuration(0.2, animations: {
               self.tripSectionButton.hidden = false
               }, completion: {
                  (value: Bool) in
                  if self.nextButton.hidden {
                     self.nextButton.hidden = false
                     self.view.addConstraint(self.nextButtonConstraints["Top"]!)
                     self.nextButton.layoutIfNeeded()
                  }
            })
            self.endingLocation.resignFirstResponder()
         }
      }
      return true
   }
   
   func reviewLocations(sender: UIButton) {
      if self.section == 1 || self.section == 3 {
         seekOfferSegment.hidden = false
         startingLocation.hidden = false
         endingLocation.hidden = false
         seekOfferSegment.alpha = 0
         startingLocation.alpha = 0
         endingLocation.alpha = 0
         
         if self.section == 1 {
            dateButton.hidden = true
            timeButton.hidden = true
            datePicker.alpha = 0
            timePicker.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
               
               self.seekOfferSegment.alpha = 1
               self.startingLocation.alpha = 1
               self.endingLocation.alpha = 1
               
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
               self.startingLocation.alpha = 1
               self.endingLocation.alpha = 1
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
      if self.section == 0 || self.section == 3 {
         dateButton.hidden = false
         timeButton.hidden = false
         self.dateButton.alpha = 0
         self.timeButton.alpha = 0
         
         if self.section == 0 {
            seekOfferSegment.hidden = true
            startingLocation.hidden = true
            endingLocation.hidden = true
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
            startingLocation.hidden = true
            endingLocation.hidden = true
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
         self.setDateTimeString()
         seekOfferSegment.hidden = true
         startingLocation.hidden = true
         endingLocation.hidden = true
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
   
   func setTripString(start: String, end: String) {
      var tripString = NSAttributedString(string: start + " \u{2192} " + end, attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 22.0)!])
      tripSectionButton.setAttributedTitle(tripString, forState: .Normal)
      
      tripLabel.attributedText = NSAttributedString(string: start + " \u{2192} " + end, attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 24.0)!])
   }
   
   func setDateTimeString() {
      let tempDate = self.dateButton.currentAttributedTitle?.string
      let tempTime = self.timeButton.currentAttributedTitle?.string
      let range = NSMakeRange(countElements(tempDate!)-2, 2)
      
      var tripString = NSMutableAttributedString(string: tempDate! + " " + tempTime!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 22.0)!])
      tripString.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 14)!, kCTSuperscriptAttributeName: 1.5], range: range)
      dateTimeSectionButton.setAttributedTitle(tripString, forState: .Normal)
      dateTimeSectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      
      let currentDateArr = tempDate!.componentsSeparatedByString(" ")
      var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
      date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: range)
      date.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 30)!, range: NSMakeRange(countElements(currentDateArr[0])-1, 1))
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
         var start = advance(dateString.startIndex, countElements(dateString) - 2)
         var end = advance(dateString.startIndex, countElements(dateString) - 1)
         var day_of_month = dateString.substringFromIndex(start).toInt()!
         
         if day_of_month < 10 {
            dateString = dateString.stringByReplacingCharactersInRange(Range<String.Index>(start: start,end: end), withString: "")
         }
         
         switch (day_of_month) {
         case 1 : dateString += "st"
         case 21: dateString += "st"
         case 31: dateString += "st"
         case 2: dateString += "nd"
         case 22: dateString += "nd"
         case 3: dateString += "rd"
         case 23: dateString += "rd"
         default: dateString += "th"
         }
         
         currentDates.append(dateString)
      }
   }
   
   func getTimes() {
      times.append("ANYTIME")
      for i in 1 ..< 12 {
         times.append("\(i%12):00")
      }
   }
   
   //MARK: - Delegates and data sources
   //MARK: Data Sources
   func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
      if pickerView == datePicker {
         return 1
      } else {
         return 2
      }
   }
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      if pickerView == datePicker {
         return currentDates.count
      } else {
         if (component == 0) {
            return times.count
         } else  {
            return 3
         }
      }
   }
   
   //MARK: Delegates
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if pickerView == datePicker {
         let currentDateArr = currentDates[row].componentsSeparatedByString(" ")
         var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
         date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(countElements(date.string)-2, 2))
         dateButton.setAttributedTitle(date, forState: .Normal)
      } else {
         if component == 0 {
            if row == 0 {
               timePicker.selectRow(0, inComponent: 1, animated: true)
            } else if timePicker.selectedRowInComponent(1) == 0 {
               timePicker.selectRow(1, inComponent: 1, animated: true)
            }
         } else {
            if timePicker.selectedRowInComponent(0) == 0 && row > 0 {
               timePicker.selectRow(1, inComponent: 0, animated: true)
            }
         }
         let selectedTime = timePicker.viewForRow(timePicker.selectedRowInComponent(0), forComponent: 0) as UILabel
         let selectedAMPM = timePicker.viewForRow(timePicker.selectedRowInComponent(1), forComponent: 1) as UILabel
         timeButton.setAttributedTitle(createAttributedString(selectedTime.text!, str2: selectedAMPM.text!, color: UIColor.whiteColor()), forState: .Normal)
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
         var date = NSMutableAttributedString(string: currentDates[row])
         date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 13)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(countElements(date.string)-2, 2))
         pickerLabel.attributedText = date
      } else {
         if (component == 0) {
            pickerLabel.text = times[row]
         } else  {
            pickerLabel.text = ampm[row]
         }
      }
      return pickerLabel
   }
   
   func createAttributedString(str1: String, str2: String, color: UIColor) -> NSMutableAttributedString {
      var myString = NSMutableAttributedString(string: str1 + " " + str2)
      myString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 30)!, range: NSMakeRange(0, countElements(str1)))
      myString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 30)!, range: NSMakeRange(countElements(str1)+1, countElements(str2)))
      myString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, myString.length))
      return myString
      
   }
   
   func postRide(sender: UIButton) {
      let type = seekOfferSegment.selectedSegmentIndex == 0 ? "Seeking" : "Offering"
      let start = startingLocation.text!
      let end = endingLocation.text!
      let day = dateLabel.text!
      let time = timeLabel.text!
      let driverEnum = seekOfferSegment.selectedSegmentIndex == 0 ? "rider" : "driver"
      
      let urlString = "http://ec2-54-148-100-12.us-west-2.compute.amazonaws.com/pixie/posts";
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
      var session = NSURLSession.sharedSession();
      request.HTTPMethod = "POST"
      
      var userId = "2";
      var err: NSError?
      let defaults = NSUserDefaults.standardUserDefaults()
      if let savedId = defaults.stringForKey("PixieUserId") {
         userId = savedId;
         println("saved id");
      }
      var reqText = ["day": day, "driverEnum": driverEnum, "end": end, "userId": userId, "start": start, "time": time]
      
      request.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqText, options: nil, error: &err)
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
         var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
         if(err != nil) {
            println(err!.localizedDescription)
         }
         else {
            println(strData)
         }
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
   
   func delay(delay:Double, closure:()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   // handles hiding keyboard when user touches outside of keyboard
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
}