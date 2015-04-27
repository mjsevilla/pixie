//
//  Post.swift
//  PixieMatches
//
//  Created by Nicole on 2/15/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class Post {
   let isDriver: Bool
   let startingLoc: String
   let endingLoc: String
   let date: String
   let time: String
   let userId: Int
   
   init(isDriver: Bool, start: String, end: String, date: String, time: String, userId: Int) {
      self.isDriver = isDriver
      self.startingLoc = start
      self.endingLoc = end
      self.date = date
      self.time = time
      self.userId = userId;
   }
   
   func toString() {
      println("isDriver: \(isDriver)")
      println("start: \(startingLoc)")
      println("end: \(endingLoc)")
      println("date: \(date)")
      println("time: \(time)")
      println("userId: \(userId)")
   }
}