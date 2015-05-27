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
   var start: Location!
   var end: Location!
   var day: String!
   var dayFormatStr: String!
   var time: String!
   var timeFormatStr: String!
   var id: Int!
   var userId: Int!
   
   init(isDriver: Bool, start: Location, end: Location, day: String, time: String, id: Int, userId: Int) {
      self.isDriver = isDriver
      self.start = start
      self.end = end
      self.dayFormatStr = day
      self.day = getDay(day)
      self.timeFormatStr = time
      self.time = getTime(time)
      self.id = id
      self.userId = userId;
   }
   
   func getDay(dayFormatStr: String) -> String {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      var dayDate = dateFormatter.dateFromString(dayFormatStr)
      dateFormatter.dateFormat = "EEEE, MMMM d"
      
//      let temp = dateFormatter.stringFromDate(dayDate!)
//      println("getDay(\(dayFormatStr)) -> \(temp)")
//      println("getDayFormatStr(\(temp)) -> \(getDayFormatStr(temp))")
      
      return dateFormatter.stringFromDate(dayDate!)
   }
   
   func getDayFormatStr(day: String) -> String {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEEE, MMMM d"
      var dayDate = dateFormatter.dateFromString(day)
      dateFormatter.dateFormat = "yyyy"
      var currentYear = dateFormatter.stringFromDate(NSDate()).toInt()!
      
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: dayDate!)
      let componentsNow = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate())
      if componentsNow < components {
         currentYear += 1
      }
      
      dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
      dayDate = dateFormatter.dateFromString("\(day) \(currentYear)")
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.stringFromDate(dayDate!)
   }
   
   func getTime(timeFormatStr: String) -> String {
      if timeFormatStr == "25:00:00" {
         return "ANYTIME"
      }
      
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      var timeDate = dateFormatter.dateFromString(timeFormatStr)
      dateFormatter.dateFormat = "h:mm a"
      
//      let temp = dateFormatter.stringFromDate(timeDate!)
//      println("getTime(\(timeFormatStr)) -> \(temp)")
//      println("getTimeFormatStr(\(temp)) -> \(getTimeFormatStr(temp))\n")
      
      return dateFormatter.stringFromDate(timeDate!)
   }
   
   func getTimeFormatStr(time: String) -> String {
      if timeFormatStr == "ANYTIME" {
         return "25:00:00"
      }
      
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "h:mm a"
      var timeDate = dateFormatter.dateFromString(time)
      dateFormatter.dateFormat = "HH:mm:ss"
      return dateFormatter.stringFromDate(timeDate!)

   }
   
   func toString() {
      println("userId: \(userId), postId: \(id)")
      println("isDriver: \(isDriver)")
      println("start: \(start.toString())")
      println("end: \(end.toString())")
      println("date: \(day), time: \(time)")
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