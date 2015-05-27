//
//  EditPostViewController.swift
//  Pixie
//
//  Created by Nicole on 4/27/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   
   var blurEffectView : UIVisualEffectView!
   
   var seekOfferSegment: UISegmentedControl!
   var startingLocation: UITextField!
   var endingLocation: UITextField!
   
   var dateButton: UIButton!
   var datePicker: UIPickerView!
   var timeButton: UIButton!
   var timePicker: UIPickerView!
   var currentDates: [String] = []
   var times: [String] = []
   var ampm: [String] = ["", "AM", "PM"]
   
   var cancelButton: UIButton!
   var saveButton: UIButton!
   
   var timeButtonConstraints = [String: NSLayoutConstraint]()
   
   var currentPost: Post!
   var currentPostIndex: Int!
   var hasSmallHeight: Bool!
   var shouldSavePost: Bool!
   
   override func loadView() {
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
      seekOfferSegment.setTranslatesAutoresizingMaskIntoConstraints(false)
      seekOfferSegment.tintColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0)
      view.addSubview(seekOfferSegment)
      
      let leftPaddingViewStart = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
      leftPaddingViewStart.backgroundColor = UIColor.clearColor()
      let leftPaddingViewEnd = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
      leftPaddingViewEnd.backgroundColor = UIColor.clearColor()
      
      startingLocation = UITextField()
      startingLocation.leftView = leftPaddingViewStart
      startingLocation.leftViewMode = .Always
      startingLocation.backgroundColor = UIColor.clearColor()
      startingLocation.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      startingLocation.textColor = UIColor.whiteColor()
      startingLocation.layer.cornerRadius = 8.0
      startingLocation.layer.masksToBounds = true
      startingLocation.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      startingLocation.layer.borderWidth = 1.0
      startingLocation.delegate = self
      startingLocation.hidden = false
      startingLocation.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(startingLocation)
      
      endingLocation = UITextField()
      endingLocation.leftView = leftPaddingViewEnd
      endingLocation.leftViewMode = .Always
      endingLocation.backgroundColor = UIColor.clearColor()
      endingLocation.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
      endingLocation.textColor = UIColor.whiteColor()
      endingLocation.layer.cornerRadius = 8.0
      endingLocation.layer.masksToBounds = true
      endingLocation.layer.borderColor = UIColor(red:0.0, green:0.74, blue:0.82, alpha:1.0).CGColor
      endingLocation.layer.borderWidth = 1.0
      endingLocation.delegate = self
      endingLocation.hidden = false
      endingLocation.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(endingLocation)
      
      getCurrentDates()
      getTimes()
      
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
      timeButton.setAttributedTitle(NSAttributedString(string: times[0], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30.0)!]), forState: .Normal)
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
      let viewsDict = ["blurEffectView":blurEffectView, "seekOfferSegment":seekOfferSegment, "startingLocation":startingLocation, "endingLocation":endingLocation, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker, "cancelButton":cancelButton, "saveButton":saveButton]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]-20-[startingLocation(30)]-10-[endingLocation(30)]-10-[dateButton]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(40)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(40)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[timePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cancelButton]-0-[saveButton(==cancelButton)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.layoutIfNeeded()
      
      timeButtonConstraints["Top"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: datePicker.frame.height)
      
      self.view.addConstraint(NSLayoutConstraint(item: dateButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: hasSmallHeight! ? -dateButton.frame.height*0.75 : 0))
      self.view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0))
      self.view.addConstraint(timeButtonConstraints["Top"]!)
      self.view.addConstraint(NSLayoutConstraint(item: timePicker, attribute: .Top, relatedBy: .Equal, toItem: timeButton, attribute: .Bottom, multiplier: 1, constant: 0))
      self.view.layoutIfNeeded()
      
      //      let viewsDict = ["blurEffectView":blurEffectView, "seekOfferSegment":seekOfferSegment, "startingLocation":startingLocation, "endingLocation":endingLocation, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker, "cancelButton":cancelButton, "saveButton":saveButton]
      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[seekOfferSegment(40)]-[startingLocation(>=20,<=40)]-[endingLocation(==startingLocation)]-[dateButton]", options: NSLayoutFormatOptions.AlignAllCenterX | NSLayoutFormatOptions.AlignAllLeading | NSLayoutFormatOptions.AlignAllTrailing, metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-70-[seekOfferSegment(40)]-[startingLocation(>=20,<= 40)]-10-[endingLocation(==startingLocation)]-[dateButton]-[timeButton]", options: NSLayoutFormatOptions.AlignAllCenterX | NSLayoutFormatOptions.AlignAllLeading | NSLayoutFormatOptions.AlignAllTrailing, metrics: nil, views: viewsDict))
      //
      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(>=40,<=80)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(>=40,<=80)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      //      //      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
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
         startingLocation.text = current.start.name
         endingLocation.text = current.end.name
         
         if let dateIdx = find(currentDates, current.day) {
            let currentDateArr = currentDates[dateIdx].componentsSeparatedByString(" ")
            var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
            dateButton.setAttributedTitle(date, forState: .Normal)
            datePicker.selectRow(dateIdx, inComponent: 0, animated: false)
         }
         
         if time == "ANYTIME" {
            timePicker.selectRow(0, inComponent: 0, animated: false)
         }
         else {
            let timeStr = time.substringWithRange(Range<String.Index>(start: time.startIndex, end: advance(time.endIndex, -2))).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let ampmStr = time.substringWithRange(Range<String.Index>(start: advance(time.endIndex, -2), end: time.endIndex))
            
            if let timeStrIdx = find(times, timeStr) {
               timePicker.selectRow(timeStrIdx, inComponent: 0, animated: false)
               
               if ampmStr == "AM" {
                  timePicker.selectRow(1, inComponent: 1, animated: false)
               } else if ampmStr == "PM" {
                  timePicker.selectRow(2, inComponent: 1, animated: false)
               }
            }
         }
         
         let selectedTime = timePicker.viewForRow(timePicker.selectedRowInComponent(0), forComponent: 0) as! UILabel
         let selectedAMPM = timePicker.viewForRow(timePicker.selectedRowInComponent(1), forComponent: 1) as! UILabel
         timeButton.setAttributedTitle(createAttributedString(selectedTime.text!, str2: selectedAMPM.text!, color: UIColor.whiteColor()), forState: .Normal)
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
   
   func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 26.0
   }
   
   //MARK: Delegates
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if pickerView == datePicker {
         let currentDateArr = currentDates[row].componentsSeparatedByString(" ")
         var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
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
         let selectedTime = timePicker.viewForRow(timePicker.selectedRowInComponent(0), forComponent: 0) as! UILabel
         let selectedAMPM = timePicker.viewForRow(timePicker.selectedRowInComponent(1), forComponent: 1) as! UILabel
         timeButton.setAttributedTitle(createAttributedString(selectedTime.text!, str2: selectedAMPM.text!, color: UIColor.whiteColor()), forState: .Normal)
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
            pickerLabel.text = times[row]
         } else  {
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
   
   func getTimes() {
      times.append("ANYTIME")
      for i in 1 ..< 12 {
         times.append("\(i%12):00")
      }
   }
   
   func cancel(sender: UIButton) {
      self.performSegueWithIdentifier("unwindToMyPosts", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   func save(sender: UIButton) {
      let driverEnum = !(seekOfferSegment.selectedSegmentIndex == 0)
      let start = startingLocation.text!
      let end = endingLocation.text!
      let day = dateButton.titleLabel?.text
      let time = timeButton.titleLabel?.text
      
      // TO-DO: FIX THIS API CALL SHIT
      
//      currentPost = Post(isDriver: driverEnum, start: start, end: end, date: day!, time: time!, userId: currentPost.userId)
      shouldSavePost = true
      self.performSegueWithIdentifier("unwindToMyPosts", sender: self)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
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
   
}
