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
   
   var postRideButton: UIButton!
   
   var seekOfferSegmentConstraints = [String: NSLayoutConstraint]()
   var startingLocationConstraints = [String: NSLayoutConstraint]()
   var endingLocationConstraints = [String: NSLayoutConstraint]()
   
   var dateButtonConstraints = [String: NSLayoutConstraint]()
   var datePickerConstraints = [String: NSLayoutConstraint]()
   var timeButtonConstraints = [String: NSLayoutConstraint]()
   var timePickerConstraints = [String: NSLayoutConstraint]()
   
   var postRideButtonConstraints = [String: NSLayoutConstraint]()
   
   var currentPost: Post!
   var currentPostIndex: Int!
   
   override func loadView() {
      view = UIView(frame: UIScreen.mainScreen().bounds)
      
      loadViews()
      loadConstraints()
      setValues()
      
      let viewsDict = ["blurEffectView":blurEffectView]
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
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
      date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(count(date.string)-2, 2))
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
      
   }
   
   func loadConstraints() {
      let viewsDict = ["blurEffectView":blurEffectView, "seekOfferSegment":seekOfferSegment, "startingLocation":startingLocation, "endingLocation":endingLocation, "dateButton":dateButton, "datePicker":datePicker, "timeButton":timeButton, "timePicker":timePicker]
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startingLocation(30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[endingLocation(30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timePicker(162)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[seekOfferSegment]-20-[startingLocation]-10-[endingLocation]-10-[dateButton]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seekOfferSegment]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[startingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[endingLocation]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dateButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeButton]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[timePicker]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      self.view.layoutIfNeeded()
      
      dateButtonConstraints["CenterY"] = NSLayoutConstraint(item: dateButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
      datePickerConstraints["Top"] = NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["Top"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: 0)
      timeButtonConstraints["TopExpanded"] = NSLayoutConstraint(item: timeButton, attribute: .Top, relatedBy: .Equal, toItem: dateButton, attribute: .Bottom, multiplier: 1, constant: datePicker.frame.height)
      timePickerConstraints["Top"] = NSLayoutConstraint(item: timePicker, attribute: .Top, relatedBy: .Equal, toItem: timeButton, attribute: .Bottom, multiplier: 1, constant: 0)
      
      self.view.addConstraint(dateButtonConstraints["CenterY"]!)
      self.view.addConstraint(datePickerConstraints["Top"]!)
      self.view.addConstraint(timeButtonConstraints["Top"]!)
      self.view.addConstraint(timePickerConstraints["Top"]!)
      self.view.layoutIfNeeded()
   }
   
   func setValues() {
      if let current = currentPost {
         let time = current.time
         
         seekOfferSegment.selectedSegmentIndex = current.isDriver ? 1 : 0
         startingLocation.text = current.startingLoc
         endingLocation.text = current.endingLoc
         
         if let dateIdx = find(currentDates, current.date) {
            let currentDateArr = currentDates[dateIdx].componentsSeparatedByString(" ")
            var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
            date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(count(date.string)-2, 2))
            dateButton.setAttributedTitle(date, forState: .Normal)
            datePicker.selectRow(dateIdx, inComponent: 0, animated: false)
         }

         if time == "ANYTIME" {
            timePicker.selectRow(0, inComponent: 0, animated: false)
         }
         else {
            let timeStr = time.substringWithRange(Range<String.Index>(start: time.startIndex, end: advance(time.endIndex, -2)))
            let ampmStr = time.substringWithRange(Range<String.Index>(start: advance(time.endIndex, -2), end: time.endIndex)).lowercaseString
            
            println("timeStr: \(timeStr), ampmStr: \(ampmStr)")
            
            if let timeStrIdx = find(times, timeStr) {
               datePicker.selectRow(timeStrIdx, inComponent: 0, animated: false)
            }
            
            if ampmStr == "am" {
               datePicker.selectRow(0, inComponent: 1, animated: false)
            } else if ampmStr == "pm" {
               datePicker.selectRow(1, inComponent: 1, animated: false)
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
   
   //MARK: Delegates
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if pickerView == datePicker {
         let currentDateArr = currentDates[row].componentsSeparatedByString(" ")
         var date = NSMutableAttributedString(attributedString: createAttributedString(currentDateArr[0], str2: currentDateArr[1]+" "+currentDateArr[2], color: UIColor.whiteColor()))
         date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 19.5)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(count(date.string)-2, 2))
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
         var date = NSMutableAttributedString(string: currentDates[row])
         date.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 13)!, kCTSuperscriptAttributeName: 1.5], range: NSMakeRange(count(date.string)-2, 2))
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

}
