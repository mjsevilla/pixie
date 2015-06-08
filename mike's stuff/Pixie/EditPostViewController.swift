//
//  EditPostViewController.swift
//  Pixie
//
//  Created by Nicole on 4/27/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
   
   var startingVC = GooglePlacesAutocompleteContainer(apiKey: "AIzaSyB6Gv8uuTNh_ZN-Hk8H3S5RARpQot_6I-k", placeType: .All)
   var startingTableView: UITableView!
   var endingVC = GooglePlacesAutocompleteContainer(apiKey: "AIzaSyB6Gv8uuTNh_ZN-Hk8H3S5RARpQot_6I-k", placeType: .All)
   var endingTableView: UITableView!
   
   var activeSearchBar: UISearchBar!
   @IBOutlet weak var startingSearchBar: UISearchBar!
   @IBOutlet weak var endingSearchBar: UISearchBar!
   
   var blurEffectView : UIVisualEffectView!
   
   var seekOfferSegment: UISegmentedControl!
   var startingLocTextField: UITextField!
   var endingLocTextField: UITextField!
   var searchBarsVisible = true
   
   var dateButton: UIButton!
   var datePicker: UIPickerView!
   var timeButton: UIButton!
   var timePicker: UIPickerView!
   var currentDates: [String] = []
   var hours: [String] = ["ANYTIME", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
   var minutes: [String] = ["", "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
   var ampm: [String] = ["", "AM", "PM"]
   
   var cancelButton: UIButton!
   var saveButton: UIButton!
   
   var startingSearchBarConstraints = [String: NSLayoutConstraint]()
   var endingSearchBarConstraints = [String: NSLayoutConstraint]()
   var timeButtonConstraints = [String: NSLayoutConstraint]()
   
   var currentPost: Post!
   var currentPostIndex: Int!
   var hasSmallHeight: Bool!
   var shouldSavePost: Bool!
   
   override func loadView() {
      super.loadView()
      view = UIView(frame: UIScreen.mainScreen().bounds)
      hasSmallHeight = view.frame.height <= 480.0 ? true : false
      shouldSavePost = false
      
      loadViews()
      loadConstraints()
      setValues()
      
      view.layoutIfNeeded()
      
      var swipeAway = UISwipeGestureRecognizer(target: self, action: "swipeAway:")
      swipeAway.direction = .Down
      view.addGestureRecognizer(swipeAway)
   }
   
   func loadViews() {
      blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
      blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(blurEffectView)
      
      seekOfferSegment = UISegmentedControl()
      seekOfferSegment.insertSegmentWithTitle("SEEKING", atIndex: 0, animated: false)
      seekOfferSegment.insertSegmentWithTitle("OFFERING", atIndex: 1, animated: false)
      var attr = NSDictionary(object: UIFont(name: "Syncopate-Regular", size: 16.0)!, forKey: NSFontAttributeName)
      seekOfferSegment.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
      seekOfferSegment.addTarget(self, action: "segmentValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
      seekOfferSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
      seekOfferSegment.tintColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      view.addSubview(seekOfferSegment)
      
      activeSearchBar = startingSearchBar
      
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
      
      startingVC.delegate = self
      startingSearchBar.delegate = self
      startingVC.searchBar = self.startingSearchBar
      startingVC.tableView = self.startingTableView
      
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
      
      endingVC.delegate = self
      endingSearchBar.delegate = self
      endingVC.searchBar = self.endingSearchBar
      endingVC.tableView = self.endingTableView
      
      getCurrentDates()
      
      dateButton = UIButton()
      dateButton.addTarget(self, action: "selectDate:", forControlEvents: UIControlEvents.TouchUpInside)
      let currentDateArr = currentDates[0].componentsSeparatedByString(" ")
      var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
      dateButton.setAttributedTitle(date, forState: .Normal)
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
      view.addSubview(timeButton)
      
      timePicker = UIPickerView()
      timePicker.delegate = self
      timePicker.dataSource = self
      timePicker.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
      timePicker.hidden = true;
      timePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(timePicker)
      
      cancelButton = UIButton()
      cancelButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      cancelButton.setAttributedTitle(NSAttributedString(string: "CaNCeL", attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "Syncopate-Regular", size: 18.0)!]), forState: .Normal)
      cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      cancelButton.addTarget(self, action: "cancel:", forControlEvents: .TouchUpInside)
      cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(cancelButton)
      
      saveButton = UIButton()
      saveButton.backgroundColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      saveButton.setAttributedTitle(NSAttributedString(string: "SaVe", attributes: [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "Syncopate-Regular", size: 18.0)!]), forState: .Normal)
      saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
      saveButton.addTarget(self, action: "save:", forControlEvents: .TouchUpInside)
      saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(saveButton)
      
   }
   
   func loadConstraints() {
      let viewsDict = ["blurEffectView":blurEffectView, "seekOfferSegment":seekOfferSegment, "startingSearchBar":startingSearchBar, "endingSearchBar":endingSearchBar, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker, "cancelButton":cancelButton, "saveButton":saveButton, "startTable":startingTableView, "endTable":endingTableView]
      let metrics = ["tableHeight":38*5]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
//      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]-20-[startingSearchBar(30)]-10-[endingSearchBar(30)]-10-[dateButton]", options: .AlignAllCenterX, metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]-100-[dateButton]", options: .AlignAllCenterX, metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startingSearchBar(30)]", options: .AlignAllCenterX, metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[endingSearchBar(30)]", options: .AlignAllCenterX, metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startingSearchBar]-1-[startTable]-[saveButton]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[endingSearchBar]-1-[endTable]-[saveButton]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(40)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(40)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[startTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[endTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[timePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cancelButton]-0-[saveButton(==cancelButton)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.layoutIfNeeded()
      
      startingSearchBarConstraints["Top"] = NSLayoutConstraint(item: startingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: seekOfferSegment, attribute: .Bottom, multiplier: 1, constant: 20)
      endingSearchBarConstraints["Top"] = NSLayoutConstraint(item: endingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: seekOfferSegment, attribute: .Bottom, multiplier: 1, constant: 60)
      startingSearchBarConstraints["Search"] = NSLayoutConstraint(item: startingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 70)
      endingSearchBarConstraints["Search"] = NSLayoutConstraint(item: endingSearchBar, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 70)
      timeButtonConstraints["Top"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: datePicker.frame.height)
      
      self.view.addConstraint(startingSearchBarConstraints["Top"]!)
      self.view.addConstraint(endingSearchBarConstraints["Top"]!)
      self.view.addConstraint(NSLayoutConstraint(item: dateButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: hasSmallHeight! ? -dateButton.frame.height*0.75 : 0))
      self.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0))
      self.view.addConstraint(timeButtonConstraints["Top"]!)
      self.view.addConstraint(NSLayoutConstraint(item: timePicker, attribute: .Top, relatedBy: .Equal, toItem: timeButton, attribute: .Bottom, multiplier: 1, constant: 0))
      self.view.layoutIfNeeded()
      
      //      let viewsDict = ["blurEffectView":blurEffectView, "seekOfferSegment":seekOfferSegment, "startingSearchBar":startingSearchBar, "endingSearchBar":endingSearchBar, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker, "cancelButton":cancelButton, "saveButton":saveButton]
      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[seekOfferSegment(40)]-[startingSearchBar(>=20,<=40)]-[endingSearchBar(==startingSearchBar)]-[dateButton]", options: NSLayoutFormatOptions.AlignAllCenterX | NSLayoutFormatOptions.AlignAllLeading | NSLayoutFormatOptions.AlignAllTrailing, metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[seekOfferSegment(40)]-[startingSearchBar(>=20,<= 40)]-10-[endingSearchBar(==startingSearchBar)]-[dateButton]-[timeButton]", options: NSLayoutFormatOptions.AlignAllCenterX | NSLayoutFormatOptions.AlignAllLeading | NSLayoutFormatOptions.AlignAllTrailing, metrics: nil, views: viewsDict))
      //
      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(>=40,<=80)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(>=40,<=80)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingSearchBar]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[timePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cancelButton]-0-[saveButton(==cancelButton)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //
      //      //      self.view.layoutIfNeeded()
      //      //
      //      //      timeButtonConstraints["Top"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      //      //      timeButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: datePicker.frame.height)
      //      //
      //      self.view.addConstraint(NSLayoutConstraint(item: dateButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: /*hasSmallHeight! ? -dateButton.frame.height*0.75 :*/ 0))
      //      //      self.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0))
      //      //      self.view.addConstraint(timeButtonConstraints["Top"]!)
      //      //      self.view.addConstraint(NSLayoutConstraint(item: timePicker, attribute: .Top, relatedBy: .Equal, toItem: timeButton, attribute: .Bottom, multiplier: 1, constant: 0))
   }
   
   func setValues() {
      if let current = currentPost {
         let time = current.time.uppercaseString
         
         seekOfferSegment.selectedSegmentIndex = current.isDriver ? 1 : 0
         startingSearchBar.text = current.start.name
         endingSearchBar.text = current.end.name
         
         if let dateIdx = find(currentDates, current.day) {
            let currentDateArr = currentDates[dateIdx].componentsSeparatedByString(" ")
            var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
            dateButton.setAttributedTitle(date, forState: .Normal)
            datePicker.selectRow(dateIdx, inComponent: 0, animated: false)
         }
         
         if time == "ANYTIME" {
            timePicker.selectRow(0, inComponent: 0, animated: false)
            timePicker.selectRow(0, inComponent: 1, animated: false)
            timePicker.selectRow(0, inComponent: 2, animated: false)
         }
         else {
            let timeStr = time.substringWithRange(Range<String.Index>(start: time.startIndex, end: advance(time.endIndex, -2))).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let timeArr = timeStr.componentsSeparatedByString(":")
            let hourStr = timeArr[0]
            let minStr = timeArr[1]
            let ampmStr = time.substringWithRange(Range<String.Index>(start: advance(time.endIndex, -2), end: time.endIndex))
            
            if let hourStrIdx = find(hours, hourStr) {
               timePicker.selectRow(hourStrIdx, inComponent: 0, animated: false)
            } else {
               println("error: couldn't find hourStr -> \(hourStr)")
            }
            if let minStrIdx = find(minutes, minStr) {
               timePicker.selectRow(minStrIdx, inComponent: 1, animated: false)
            } else {
               println("error: couldn't find minStr -> \(minStr)")
            }
            if ampmStr == "AM" {
               timePicker.selectRow(1, inComponent: 2, animated: false)
            } else if ampmStr == "PM" {
               timePicker.selectRow(2, inComponent: 2, animated: false)
            }
         }
         
         var selectedTime = hours[timePicker.selectedRowInComponent(0)]
         if timePicker.selectedRowInComponent(0) != 0 {
            selectedTime += ":\(minutes[timePicker.selectedRowInComponent(1)])"
         }
         let selectedAMPM = ampm[timePicker.selectedRowInComponent(2)]
         timeButton.setAttributedTitle(createAttributedString(selectedTime, str2: selectedAMPM, color: UIColor.whiteColor()), forState: .Normal)
         currentPost.timeFormatStr = currentPost.getTimeFormatStr("\(selectedTime) \(selectedAMPM)")
      }
   }
   
   func segmentValueChanged(sender: AnyObject) {
      currentPost.setDriverEnum(seekOfferSegment.selectedSegmentIndex)
   }
   
   func searchBarSearchButtonClicked(searchBar: UISearchBar) {
      self.view.endEditing(true)
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
         currentPost.dayFormatStr = currentPost.getDayFormatStr(currentDates[row])
         currentPost.day = currentDates[row]
         
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
         currentPost.time = "\(selectedTime) \(selectedAMPM)"
         currentPost.timeFormatStr = currentPost.getTimeFormatStr(currentPost.time)
      }
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
   
   func selectDate(button: UIButton) {
      if datePicker.hidden {
         self.datePicker.hidden = false
         self.datePicker.alpha = 0
         
         UIView.animateWithDuration(0.2, animations: {
            self.datePicker.alpha = 1
            
            if !self.timePicker.hidden {
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
            
            if !self.datePicker.hidden {
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
            }, completion: {
               (value: Bool) in
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
   
   func cancel(sender: UIButton) {
      self.performSegueWithIdentifier("unwindToMyPosts", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   func okToSave() -> Bool {
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
   
   func save(sender: UIButton) {
      //      currentPost.toString()
      
      if !okToSave() {
         return
      }
      startingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      endingSearchBar.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      
      let urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/posts";
      var request = NSMutableURLRequest(URL: NSURL(string: urlString)!);
      var session = NSURLSession.sharedSession();
      request.HTTPMethod = "PUT"
      var err: NSError?
      
      var reqText = ["start_name": currentPost.start.name, "start_lat": currentPost.start.latitude, "start_lon": currentPost.start.longitude, "end_name": currentPost.end.name, "end_lat": currentPost.end.latitude, "end_lon": currentPost.end.longitude, "day": currentPost.dayFormatStr, "driver_enum": currentPost.driverEnum, "time": currentPost.timeFormatStr, "userId": currentPost.userId]
      
//      println("\nreqText...\(reqText)")
      
      
      // TO-DO: FIX THIS API CALL SHIT
      
      //      currentPost = Post(isDriver: driverEnum, start: start, end: end, date: day!, time: time!, userId: currentPost.userId)
      shouldSavePost = true
      self.performSegueWithIdentifier("unwindToMyPosts", sender: self)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.startingVC.viewDidLoad()
      self.endingVC.viewDidLoad()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func swipeAway(recognizer: UISwipeGestureRecognizer) {
      self.performSegueWithIdentifier("unwindToMyPosts", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if (segue.identifier == "unwindToMyPosts" && shouldSavePost!) {
         if let toViewController = segue.destinationViewController as? MyPostsViewController {
            toViewController.posts[toViewController.currentPostIndex!] = currentPost
            toViewController.tableView.reloadData()
         }
      }
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
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      self.view.endEditing(true)
      
      if (activeSearchBar == startingSearchBar) {
         startingVC.delegate?.placeSelected?(startingVC.places[indexPath.row])
         let place = startingVC.places[indexPath.row]
         place.getDetails { details in
            self.currentPost.start = Location(name: "\(details.city), \(details.state)", lat: details.latitude, long: details.longitude)
            self.startingSearchBar.text = details.city + ", " + details.state
         }
         self.startingTableView.hidden = true
         self.endingSearchBar.hidden = false
         self.dateButton.hidden = false
         self.timeButton.hidden = false
         startingSearchBar.resignFirstResponder()
         if endingSearchBar.text.isEmpty {
            endingSearchBar.becomeFirstResponder()
         }
      }
      else {
         endingVC.delegate?.placeSelected?(endingVC.places[indexPath.row])
         let place = endingVC.places[indexPath.row]
         place.getDetails { details in
            self.currentPost.end = Location(name: "\(details.city), \(details.state)", lat: details.latitude, long: details.longitude)
            self.endingSearchBar.text = details.city + ", " + details.state
         }
         self.endingTableView.hidden = true
         self.dateButton.hidden = false
         self.timeButton.hidden = false
         endingSearchBar.resignFirstResponder()
      }
      
      dispatch_async(dispatch_get_main_queue(),{
         self.selectedLocationInSearchBar()
      });
   }
   
   func selectedLocationInSearchBar() {
      let isStarting = activeSearchBar == startingSearchBar
      
      
      self.view.removeConstraint(isStarting ? self.startingSearchBarConstraints["Search"]! : self.endingSearchBarConstraints["Search"]!)
      
      UIView.animateWithDuration(0.25, animations: {
         self.view.addConstraint(isStarting ? self.startingSearchBarConstraints["Top"]! : self.endingSearchBarConstraints["Top"]!)
         self.seekOfferSegment.alpha = 1
         if isStarting {
            self.endingSearchBar.alpha = 1
         } else {
            self.startingSearchBar.alpha = 1
         }
         self.dateButton.alpha = 1
         self.timeButton.alpha = 1
         isStarting ? self.startingSearchBar.layoutIfNeeded() : self.endingSearchBar.layoutIfNeeded()
         }, completion: {
            (value: Bool) in
            if isStarting && self.endingSearchBar.text.isEmpty {
               self.startingSearchBar.resignFirstResponder()
               self.endingSearchBar.isFirstResponder()
               self.activeSearchBar = self.endingSearchBar
               self.view.removeConstraint(self.endingSearchBarConstraints["Top"]!)
               
               UIView.animateWithDuration(0.4, animations: {
                  self.view.addConstraint(self.endingSearchBarConstraints["Search"]!)
                  self.seekOfferSegment.alpha = 0
                  self.startingSearchBar.alpha = 0
                  self.dateButton.alpha = 0
                  self.timeButton.alpha = 0
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


   // MARK: - GooglePlacesAutocompleteContainer (UISearchBarDelegate)

   // handles hiding keyboard when user touches outside of keyboard
   override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      self.view.endEditing(true)
      
      if !searchBarsVisible {
         let isStarting = activeSearchBar == startingSearchBar
         self.view.removeConstraint(isStarting ? self.startingSearchBarConstraints["Search"]! : self.endingSearchBarConstraints["Search"]!)
         
         UIView.animateWithDuration(0.25, animations: {
            self.view.addConstraint(isStarting ? self.startingSearchBarConstraints["Top"]! : self.endingSearchBarConstraints["Top"]!)
            self.seekOfferSegment.alpha = 1
            if isStarting {
               self.endingSearchBar.alpha = 1
            } else {
               self.startingSearchBar.alpha = 1
            }
            self.dateButton.alpha = 1
            self.timeButton.alpha = 1
            isStarting ? self.startingSearchBar.layoutIfNeeded() : self.endingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               self.searchBarsVisible = true
         })
         isStarting ? self.startingSearchBar.resignFirstResponder() : self.endingSearchBar.resignFirstResponder()
      }
   }
   
   // MARK: - GooglePlacesAutocompleteContainer (UISearchBarDelegate)
   
   func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
      if searchBarsVisible {
         self.activeSearchBar = searchBar
      }
      
      if searchBarsVisible {
         self.searchBarsVisible = false
         let isStarting = searchBar == startingSearchBar
         
         self.view.removeConstraint(isStarting ? self.startingSearchBarConstraints["Top"]! : self.endingSearchBarConstraints["Top"]!)
         self.dateButton.alpha = 0
         self.timeButton.alpha = 0
         if !self.datePicker.hidden {
            self.datePicker.alpha = 0
         }
         if !self.timePicker.hidden {
            self.timePicker.alpha = 0
         }
         if isStarting {
            self.endingSearchBar.alpha = 0
         } else {
            self.startingSearchBar.alpha = 0
         }

         UIView.animateWithDuration(0.25, animations: {
            self.view.addConstraint(isStarting ? self.startingSearchBarConstraints["Search"]! : self.endingSearchBarConstraints["Search"]!)
            self.seekOfferSegment.alpha = 0
            if !self.datePicker.hidden {
               self.view.removeConstraint(self.timeButtonConstraints["TopExpanded"]!)
               self.view.addConstraint(self.timeButtonConstraints["Top"]!)
               self.datePicker.alpha = 0
            }
            isStarting ? self.startingSearchBar.layoutIfNeeded() : self.endingSearchBar.layoutIfNeeded()
            }, completion: {
               (value: Bool) in
               if !self.datePicker.hidden {
                  self.datePicker.hidden = true
               }
               if !self.timePicker.hidden {
                  self.timePicker.hidden = true
               }
         })
      }
   }
   
   func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
      if (searchText == "") {
         if (self.activeSearchBar == startingSearchBar) {
            startingVC.places = []
            self.startingTableView.hidden = true
         } else {
            endingVC.places = []
            self.endingTableView.hidden = true
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
                  self.startingTableView.hidden = false
                  self.endingSearchBar.hidden = true
                  self.dateButton.hidden = true
                  self.timeButton.hidden = true
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
                  self.endingTableView.hidden = false
                  self.dateButton.hidden = true
                  self.timeButton.hidden = true
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

extension EditPostViewController: GooglePlacesAutocompleteDelegate {
   func placeSelected(place: Place) {
      place.getDetails { details in
         println(details)
      }
   }
}