//
//  Post.swift
//  PixieMatches
//
//  Created by Nicole on 2/15/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class Post {
   var isDriver: Bool = false
   var driverEnum: String!
   var start: Location!
   var end: Location!
   var day: String!
   var dayFormatStr: String!
   var time: String!
   var timeFormatStr: String!
   var postId: Int!
   var userId: Int!
   
   init() {}
   
   init(isDriver: Bool, start: Location, end: Location, day: String, time: String, postId: Int, userId: Int) {
      self.isDriver = isDriver
      self.driverEnum = isDriver ? "DRIVER" : "RIDER"
      self.start = start
      self.end = end
      self.dayFormatStr = day
      self.day = getDay(day)
      self.timeFormatStr = time
      self.time = getTime(time)
      self.postId = postId
      self.userId = userId;
   }
   
   func setDriverEnum(value: Int) {
      if value == 0 {
         self.driverEnum = "RIDER"
         self.isDriver = false
      } else {
         self.driverEnum = "DRIVER"
         self.isDriver = true
      }
   }
   
   func getDay(dayFormatStr: String) -> String {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      var dayDate = dateFormatter.dateFromString(dayFormatStr)
      dateFormatter.dateFormat = "EEEE, MMMM d"
      return dateFormatter.stringFromDate(dayDate!)
   }
   
   func getDayFormatStr(day: String) -> String {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEEE, MMMM d"
      var dayDate = dateFormatter.dateFromString(day)
      dateFormatter.dateFormat = "yyyy"
      var currentYear = dateFormatter.stringFromDate(NSDate()).toInt()!
      
      let calendar = NSCalendar.currentCalendar()
      let paramMonth = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: dayDate!)
      let currentMonth = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate())
      if currentMonth > paramMonth {
         currentYear += 1
      }
      
      dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
      dayDate = dateFormatter.dateFromString("\(day) \(currentYear)")
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.stringFromDate(dayDate!)
   }
   
   func getTime(timeFormatStr: String) -> String {
      if timeFormatStr == "1 day, 1:00:00" {
         return "ANYTIME"
      }
      
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      var timeDate = dateFormatter.dateFromString(timeFormatStr)
      dateFormatter.dateFormat = "h:mm a"
      return dateFormatter.stringFromDate(timeDate!)
   }
   
   func getTimeFormatStr(time: String) -> String {
      let newTime = time.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      if newTime == "ANYTIME" {
         return "25:00:00"
      }
      
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "h:mm a"
      var timeDate = dateFormatter.dateFromString(newTime)
      dateFormatter.dateFormat = "HH:mm:ss"
      return dateFormatter.stringFromDate(timeDate!)
   }
   
   func toString() {
      if let myUserId = self.userId {
         println("userId: \(myUserId)")
      }
      if let myPostId = self.postId {
         println("postId: \(myPostId)")
      }
      if let myDriverEnum = self.driverEnum {
         println("driverEnum: \(myDriverEnum)")
      }
      if let myStart = self.start {
         println("start: \(myStart.toString())")
      }
      if let myEnd = self.end {
         println("end: \(myEnd.toString())")
      }
      if let myDay = self.day {
         println("day: \(myDay)")
      }
      if let myDayFormatStr = self.dayFormatStr {
         println("dayFormatStr: \(myDayFormatStr)")
      }
      if let myTime = self.time {
         println("time: \(myTime)")
      }
      if let myTimeFormatStr = self.timeFormatStr {
         println("timeFormatStr: \(myTimeFormatStr)")
      }
   }
}

class Location {
   let name: String
   let latitude: Double
   let longitude: Double
   
   init(name: String, lat: Double, long: Double) {
      self.name = name
      self.latitude = lat
      self.longitude = long
   }
   
   func toString() -> String {
      return "\(name), (\(latitude), \(longitude))"
   }
}